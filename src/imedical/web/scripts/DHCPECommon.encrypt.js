/// DHCPECommon.encrypt.js
/// ����ʱ��		2006.10.31
/// ������		xuwm
/// ��Ҫ����		ҳ�氲ȫ?������Ҽ�?������
/// ��Ӧ��		
/// ����޸�ʱ��	
/// ����޸���	
/// ���

function key() { 
	//��ֹshift
	if(event.shiftKey) {
		return false;
		//window.close();
	}

	//��ֹalt
	if(event.altKey) {
		return false;
		//window.close();
	}
	
	//��ֹctrl
	if(event.ctrlKey) {
		return false;
		//window.close();
	}
	
	return false;
}

document.onkeydown=key;

if (window.Event) document.captureEvents(Event.MOUSEUP);

function nocontextmenu() {
	event.cancelBubble = true
	event.returnValue = false;
	return false;
}

function norightclick(e) {
	if (window.Event){
		if (e.which == 2 || e.which == 3)
		return false;
	}
	else
		if (event.button == 2 || event.button == 3) {
		event.cancelBubble = true
		event.returnValue = false;
		return false;
	}
}

//��ֹ�Ҽ�
document.oncontextmenu = nocontextmenu;  // for IE5+
document.onmousedown = norightclick;  // for all others

function selectionempty() {
	//return false;
	document.selection.empty();
}
/*
document.onmouseup=selectionempty;
document.oncontextmenu="return false";
document.onselectstart="return false";
document.ondragstart="return false";
document.onbeforecopy="return false";
document.oncopy=selectionempty;
document.onselect=selectionempty;

document.body.onmouseup=selectionempty;
document.body.oncontextmenu="return false";
document.body.onselectstart="return false";
document.body.ondragstart="return false";
document.body.onbeforecopy="return false";
document.body.oncopy=selectionempty;
document.body.onselect=selectionempty;
*/