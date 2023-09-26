/**
* Creator:qqa
* Date;2018-08-29
* Description:
*
*/

moveElem = "";
panelElem = document.getElementById("p-panel");
dragging=false;
//监听鼠标按下事件
document.addEventListener('mousedown', function(e) {
	if(e.target.classList.contains('p-itmp-drag')){
		moveElem = e.target;
	}else{
		return;
	}

	if (e.target == moveElem) {
		dragging = true; //激活拖拽状态
		var moveElemRect = moveElem.getBoundingClientRect();
		var panelElemRect = panelElem.getBoundingClientRect();
		var moveEleLeft=moveElem.style.left;
		var moveEleTop=moveElem.style.top;
		if(moveElem.style.position=="relative"){
			tLeft = e.clientX-parseInt(moveEleLeft)/pxHTransmm;
			tTop = e.clientY-parseInt(moveEleTop)/pxHTransmm;
		}
		if(moveElem.style.position=="absolute"){
			tLeft = e.clientX - moveElemRect.left+panelElemRect.left; //鼠标按下时和选中元素的坐标偏移:x坐标
			tTop = e.clientY - moveElemRect.top+panelElemRect.top; //鼠标按下时和选中元素的坐标偏移:y坐标
		}
		
	}
});

//监听鼠标放开事件
document.addEventListener('mouseup', function(e) {
	dragging = false;
});

//监听鼠标移动事件
document.addEventListener('mousemove', function(e) {
	if (dragging) {
		var moveX = e.clientX - tLeft;
		var moveY = e.clientY - tTop;
		if(moveElem.style.position=="absolute"){
			moveElem.style.left = Number(moveX*pxHTransmm).toFixed(2) + 'mm';
			moveElem.style.top = Number(moveY*pxHTransmm).toFixed(2) + 'mm';
		}
		if(moveElem.style.position=="relative"){
			moveElem.style.left = Number(moveX*pxHTransmm).toFixed(2) + 'mm';
			moveElem.style.top = Number(moveY*pxHTransmm).toFixed(2) + 'mm';
		}	
	}
});
  