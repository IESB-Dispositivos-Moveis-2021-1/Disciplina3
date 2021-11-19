import turicreate as tc

dataset = tc.SFrame('turi_gender_dataset.sframe')

train, test = dataset.random_split(0.8)

model = tc.image_classifier.create(train, target='gender', model='VisionFeaturePrint_Scene')

metrics = model.evaluate(test)
print(metrics)

model.name = 'Classificador de Gênero (Masculino e Feminino) - IESB'
model.summary = 'Exemplo de CoreML'

model.save('turi_gender_detector.model')

# Exporta para CoreML
model.export_coreml('turi_gender_detector.mlmodel')
