import turicreate as tc
import os

#carrega as imagens em um novo dataset
dataset = tc.image_analysis.load_images('genders', with_path=True)

# Adiciona a coluna de label (classe) com base na pasta onde está a imagem
dataset['gender'] = dataset['path'].apply(lambda path: os.path.basename(os.path.dirname(path)))

# Salva o arquivo para usar no treinamento
dataset.save('turi_gender_dataset.sframe')

# Interface gráfica para dar uma olhada nos dados
dataset.explore()