import typer
import os
import librosa
import numpy as np
import faiss

app = typer.Typer()

INDEX_FILE = "muai_embeddings.index"
FILENAMES_FILE = "muai_filenames.txt"

def extract_features(file_path):
    y, sr = librosa.load(file_path)
    mfccs = np.mean(librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13), axis=1)
    return mfccs

@app.command()
def vectorize(arg: str):
    embeddings = []
    filenames = []

    if os.path.isdir(arg):  # If the argument is a directory
        for root, _, files in os.walk(arg):
            for file in files:

                if file.endswith('.wav') or file.endswith('.mp3'):
                    try:
                        file_path = os.path.join(root, file)
                        filenames.append(file_path)
                        embedding = extract_features(file_path)
                        embeddings.append(embedding)
                    except Exception as e:
                        print(f"Error processing {file_path}: {e}")
            
        embeddings = np.array(embeddings).astype('float32')
        index = faiss.IndexFlatL2(embeddings.shape[1])
        index.add(embeddings)
        faiss.write_index(index, INDEX_FILE)
        
        with open(FILENAMES_FILE, 'w') as f:
            for filename in filenames:
                f.write(filename + '\n')

        typer.echo(f"Vectorized and saved data from directory: {arg}")

    elif os.path.isfile(arg):  # If the argument is a file
        embedding = extract_features(arg).reshape(1, -1).astype('float32')
        
        if os.path.exists(INDEX_FILE):
            index = faiss.read_index(INDEX_FILE)
        else:
            index = faiss.IndexFlatL2(embedding.shape[1])
        
        index.add(embedding)
        faiss.write_index(index, INDEX_FILE)

        with open(FILENAMES_FILE, 'a') as f:
            f.write(arg + '\n')

        typer.echo(f"Vectorized and saved data from file: {arg}")

    else:
        typer.echo("Invalid path. Please provide a valid file or directory path.")

@app.command()
def similarity(file_path: str, n: int = 5):
    query_embedding = extract_features(file_path).reshape(1, -1).astype('float32')
    
    index = faiss.read_index(INDEX_FILE)
    _, indices = index.search(query_embedding, n)
    
    with open(FILENAMES_FILE, 'r') as f:
        all_filenames = f.readlines()

    similar_files = [all_filenames[i].strip() for i in indices[0]]
    
    typer.echo("Most similar files:")
    for idx, sf in enumerate(similar_files, 1):
        typer.echo(f"{idx}. {sf}")

if __name__ == "__main__":
    app()
