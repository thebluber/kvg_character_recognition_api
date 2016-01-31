'use strict';
/*jslint browser: true*/
/*global $, jQuery, alert, utils, api*/

var mobile = function(canvas, buttons) {
  var strokes = [];
  var drawing = false;
  var sending = false;
  var ctx = canvas.getContext("2d");

  //window events
  function resizeCanvas(){
    canvas.width = window.innerWidth;
    canvas.height = window.innerWidth;
  }
  window.addEventListener("resize", resizeCanvas, false);
  window.addEventListener("orientationchange", resizeCanvas, false);

  //setup canvas
  resizeCanvas();
  ctx = canvas.getContext("2d");
  ctx.strokeStyle = "#df4b26";
  //ctx.lineJoin = "round";
  ctx.lineCap = "round";
  ctx.lineWidth = 5;


  //helper function
  function addPoint2Stroke(x, y) {
    strokes[strokes.length - 1].push([x, y]);
  }

  //api callbacks
  function errorCallback(msg) {
    sending = false;
    alert(msg);
  }

  function successCallback(results) {
    sending = false;
    utils.renderResults(results.scores);
    utils.renderTimer(results.time);
  }

  //event handlers
  function startRecording(event) {
    if(!drawing){
      var x = event.pageX;
      var y = event.pageY;
      if(event.changedTouches){
        x = event.changedTouches[0].pageX;
        y = event.changedTouches[0].pageY;
      }
      x -= canvas.offsetLeft;
      y -= canvas.offsetTop;

      //Start drawing
      drawing = true;
      ctx.beginPath();
      ctx.moveTo(x, y);

      //Add start point of the stroke to the list
      strokes.push([[x,y]]);
    }
  }

  function recording(event){
    event.preventDefault();
    if(drawing){
      var x = event.changedTouches[0].pageX;
      var y = event.changedTouches[0].pageY;
      x -= canvas.offsetLeft;
      y -= canvas.offsetTop;

      ctx.lineTo(x, y);
      ctx.stroke();
      addPoint2Stroke(x, y);
    }
  }

  function stopRecording(){
    drawing = false;
    if(!sending) {
      //console.log(JSON.stringify(strokes));
      api.getScores(strokes, 10, successCallback, errorCallback);
    }
  }

  function cancelRecording(){
    drawing = false;
    sending = false;
  }

  //interactions
  function cleanAll(event){
    drawing = false;
    strokes = [];
    ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
  }

  function cleanLast(event){
    drawing = false;
    strokes.pop();
    utils.redraw(ctx, strokes);
  }

  function save(event){
    utils.save2File(strokes);
  }


  //add event listeners
  canvas.addEventListener("touchstart", startRecording, false);
  canvas.addEventListener("touchmove", recording, false);
  canvas.addEventListener("touchend", stopRecording, false);
  canvas.addEventListener("touchcancel", cancelRecording, false);

  buttons.cleanAll.addEventListener("click", cleanAll, false);
  buttons.cleanLast.addEventListener("click", cleanLast, false);
  buttons.save.addEventListener("click", save, false);
};
