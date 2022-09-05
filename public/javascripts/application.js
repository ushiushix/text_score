// Put your application scripts here

function player() {
  if ($.data(document.body, 'player') === void 0) {
  var audio5js = new Audio5js({
    swf_path: '/swf/audio5js.swf'
  });
  $.data(document.body, 'player', audio5js);
  return audio5js;
  } else {
    return $.data(document.body, 'player');
  }
}
function play(url, callback) {
  var time = Math.floor( new Date().getTime() / 1000 );
  var playURL = url;
  if (url.indexOf('?') < 0) {
		playURL = url + "?" + "t=" + time;
  }
  player().on('ended', callback);
  player().on('error', callback);
  player().load(playURL);
  player().play();
}

// Borrowed from https://richonrails.com/articles/text-area-manipulation-with-jquery
jQuery.fn.extend({
    setCursorPosition: function(position){
	if(this.length == 0) return this;
	return $(this).setSelection(position, position);
    },

    setSelection: function(selectionStart, selectionEnd) {
	if(this.length == 0) return this;
	input = this[0];

	if (input.createTextRange) {
	    var range = input.createTextRange();
	    range.collapse(true);
	    range.moveEnd('character', selectionEnd);
	    range.moveStart('character', selectionStart);
	    range.select();
	} else if (input.setSelectionRange) {
	    input.focus();
	    input.setSelectionRange(selectionStart, selectionEnd);
	}

	return this;
    },

    focusEnd: function(){
	this.setCursorPosition(this.val().length);
	return this;
    },

    getCursorPosition: function() {
	var el = $(this).get(0);
	var pos = 0;
	if('selectionStart' in el) {
	    pos = el.selectionStart;
	} else if('selection' in document) {
	    el.focus();
	    var Sel = document.selection.createRange();
	    var SelLength = document.selection.createRange().text.length;
	    Sel.moveStart('character', -el.value.length);
	    pos = Sel.text.length - SelLength;
	}
	return pos;
    },

    insertAtCursor: function(myValue) {
	return this.each(function(i) {
	    if (document.selection) {
		//For browsers like Internet Explorer
		this.focus();
		sel = document.selection.createRange();
		sel.text = myValue;
		this.focus();
	    }
	    else if (this.selectionStart || this.selectionStart == '0') {
		//For browsers like Firefox and Webkit based
		var startPos = this.selectionStart;
		var endPos = this.selectionEnd;
		var scrollTop = this.scrollTop;
		this.value = this.value.substring(0, startPos) + myValue +
		    this.value.substring(endPos,this.value.length);
		this.focus();
		this.selectionStart = startPos + myValue.length;
		this.selectionEnd = startPos + myValue.length;
		this.scrollTop = scrollTop;
	    } else {
		this.value += myValue;
		this.focus();
	    }
	})
    },
    beginningOfLine: function() {
	var pos = this.getCursorPosition();
	var nl = this.val().lastIndexOf("\n", pos);
	if (nl >= 0 && pos != (nl + 1)) {
            this.setCursorPosition(nl + 1);
	}
        return this;
    }
});
