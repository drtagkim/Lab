import io
import os
#from google.cloud import vision
#client=vision.ImageAnnotatorClient()
def get_file(client,fname):
    file_name=os.path.abspath(fname)
    with io.open(file_name,'rb') as image_file:
        content=image_file.read()
    return content
def get_image(content,vision):
    image=vision.Image(content=content)
    return image
def get_label(image,client):
    response=client.label_detection(image=image)
    labels=response.label_annotations
    mid=[i.mid for i in labels]
    description=[i.description for i in labels]
    score=[i.score for i in labels]
    topicality=[i.topicality for i in labels]
    return {
        "description":description,"score":score,
        "topicality":topicality
    }
