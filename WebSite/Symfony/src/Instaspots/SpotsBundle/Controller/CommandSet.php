<?php

namespace Instaspots\SpotsBundle\Controller;

class CommandSet
{
  const LOGIN       = "login";
  const LOGOUT      = "logout";
  const CANREGISTER = "canregister";
  const REGISTER    = "register";

  const REPORT_PROBLEM             = "reportProblem";
  const GET_CURRENT_CLIENT_VERSION = "getCurrentClientVersion";

  const UPLOAD_PICTURE_TO_SPOT = "uploadPictureToSpot";
  const UPLOAD_NEW_SPOT        = "uploadNewSpot";

  const GET_PICTURES_BY_NEWEST  = "getPicturesByNewest";
  const GET_PICTURES_BY_SPOT_ID = "getPicturesBySpotId";
  const GET_PICTURES_BY_USER_ID = "getPicturesByUserId";
  const GET_SPOTS_BY_DISTANCE   = "getSpotsByDistance";
  const GET_SPOTS_BY_USER_ID    = "getSpotsByUserId";

  const REMOVE_PICTURE = "removePicture";
}
