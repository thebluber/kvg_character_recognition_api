'use strict';
/*global $, jQuery, alert*/
/*
 * utilities
 */

var utils = {

  convertPoints2Strokes(points) {

    var strokes = [];

    for(var i=0; i<points.length; i++) {
      var curr = points[i];
      var stroke_i = curr[0] - 1;

      if(strokes[stroke_i]) {
        strokes[stroke_i].push([curr[1], curr[2]]);
      } else {
        strokes.push([[curr[1], curr[2]]]);
      }
    }

    return strokes;
  }

};
