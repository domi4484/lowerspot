from rest_framework import serializers
from spots.models import Spot
from spots.models import Picture
from django.contrib.auth.models import User


class UserSerializer(serializers.ModelSerializer):
    spots = serializers.PrimaryKeyRelatedField(many=True, queryset=Spot.objects.all())

    class Meta:
        model = User
        fields = ('id',
                  'username',
                  'spots')

class PictureSerializer(serializers.ModelSerializer):
    user = serializers.IntegerField(source='user.id', read_only=True)
    user_name = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = Picture
        fields = ('id',
                  'created',
                  'user',
                  'user_name',
                  'spot',
                  'position',
                  'published',
                  'url')


class SpotSerializer(serializers.ModelSerializer):
    user = serializers.IntegerField(source='user.id', read_only=True)
    pictures = PictureSerializer(many=True, read_only=True)

    class Meta:
        model = Spot
        fields = ('id',
                  'user',
                  'name',
                  'description',
                  'secretspot',
                  'score',
                  'position',
                  'picture1_id',
                  'picture2_id',
                  'pictures')


