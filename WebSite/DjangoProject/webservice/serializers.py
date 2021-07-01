from rest_framework import serializers
from spots.models import Spot
from spots.models import Picture
from django.contrib.auth.models import User


class UserSerializer(serializers.ModelSerializer):
    spots = serializers.PrimaryKeyRelatedField(many=True, queryset=Spot.objects.all())

    class Meta:
        model = User
        fields = ('id', 'username', 'spots')


class SpotSerializer(serializers.ModelSerializer):
    user = serializers.CharField(source='user.id', read_only=True)
    pictures = serializers.PrimaryKeyRelatedField(many=True, queryset=Picture.objects.all())

    class Meta:
        model = Spot
        fields = ('id',
                  'user',
                  'name',
                  'description',
                  'secretspot',
                  'score',
                  'latitude',
                  'longitude',
                  'picture1_id',
                  'picture2_id',
                  'pictures')


class PictureSerializer(serializers.ModelSerializer):
  user = serializers.IntegerField(source='user.id', read_only=True)
  user_name = serializers.CharField(source='user.username', read_only=True)

  class Meta:
    model = Picture
    fields = ('id', 'created', 'user', 'user_name', 'spot', 'latitude', 'longitude', 'published', 'url')
