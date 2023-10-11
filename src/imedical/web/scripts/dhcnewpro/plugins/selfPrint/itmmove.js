/**
* Creator:qqa
* Date;2018-08-29
* Description:
*
*/

moveElem = "";
panelElem = document.getElementById("p-panel");
dragging=false;
//������갴���¼�
document.addEventListener('mousedown', function(e) {
	if(e.target.classList.contains('p-itmp-drag')){
		moveElem = e.target;
	}else{
		return;
	}

	if (e.target == moveElem) {
		dragging = true; //������ק״̬
		var moveElemRect = moveElem.getBoundingClientRect();
		var panelElemRect = panelElem.getBoundingClientRect();
		var moveEleLeft=moveElem.style.left;
		var moveEleTop=moveElem.style.top;
		if(moveElem.style.position=="relative"){
			tLeft = e.clientX-parseInt(moveEleLeft)/pxHTransmm;
			tTop = e.clientY-parseInt(moveEleTop)/pxHTransmm;
		}
		if(moveElem.style.position=="absolute"){
			tLeft = e.clientX - moveElemRect.left+panelElemRect.left; //��갴��ʱ��ѡ��Ԫ�ص�����ƫ��:x����
			tTop = e.clientY - moveElemRect.top+panelElemRect.top; //��갴��ʱ��ѡ��Ԫ�ص�����ƫ��:y����
		}
		
	}
});

//�������ſ��¼�
document.addEventListener('mouseup', function(e) {
	dragging = false;
});

//��������ƶ��¼�
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
  