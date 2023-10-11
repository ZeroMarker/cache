//页面Gui
function InitFloatWin(){
	var HelpTip = document.querySelector('#HelpTip');
	var HelpTipW = HelpTip.offsetWidth;
	var HelpTipH = HelpTip.offsetHeight;
	var cuntW = 0;
	var cuntH = 0;
	//HelpTip.style.left = parseInt(Math.random() * (document.body.offsetWidth - HelpTipW)) + 'px';
	//HelpTip.style.top = parseInt(Math.random() * (document.body.offsetHeight - HelpTipH)) + 'px';
	//初始固定位置
    HelpTip.style.left = parseInt(document.body.offsetWidth - HelpTipW-15) + 'px';
	HelpTip.style.top = '15px';
	
	function move(obj, w, h) {
		if (obj.direction === 'left') {
			obj.style.left = 0 - w + 'px';
		} else if (obj.direction === 'right') {

			obj.style.left = document.body.offsetWidth - HelpTipW + w + 'px';
		}
		if (obj.direction === 'top') {
			obj.style.top = 0 - h + 'px';
		} else if (obj.direction === 'bottom') {
			obj.style.top = document.body.offsetHeight - HelpTipH + h + 'px';
		}
	}

	function rate(obj, a) {
	    //console.log(a);
		obj.style.transform = ' rotate(' + a + ')'
	}
    
	function action(obj) {
		var dir = obj.direction;
		switch (dir) {
			case 'left':
				rate(obj, '90deg');
				break;
			case 'right':
				rate(obj, '-90deg');
				break;
			case 'top':
				rate(obj, '-180deg');
				break;
			default:
				rate(obj, '-0');
				break;
		}

	}
	HelpTip.onmousedown = function (e) {
		var nekoL = e.clientX - HelpTip.offsetLeft;
		var nekoT = e.clientY - HelpTip.offsetTop;
		document.onmousemove = function (e) {
			cuntW = 0;
			cuntH = 0;
			HelpTip.direction = '';
			HelpTip.style.transition = '';
			HelpTip.style.left = (e.clientX - nekoL) + 'px';
			HelpTip.style.top = (e.clientY - nekoT) + 'px';
			if (e.clientX - nekoL < 5) {
				HelpTip.direction = 'left';
			}
			if (e.clientY - nekoT < 5) {
				HelpTip.direction = 'top';
			}
			if (e.clientX - nekoL > document.body.offsetWidth - HelpTipW - 5) {
				HelpTip.direction = 'right';
			}
			if (e.clientY - nekoT > document.body.offsetHeight - HelpTipH - 5) {
				HelpTip.direction = 'bottom';
			}

			move(HelpTip, 0, 0);


		}
	}
	HelpTip.onmouseover = function () {
		move(this, 0, 0);
		rate(this, 0)
	}

	HelpTip.onmouseout = function () {
		move(this, HelpTipW / 2, HelpTipH / 2);
		action(this);
	}

	HelpTip.onmouseup = function () {
		document.onmousemove = null;
		this.style.transition = '.5s';
		move(this, HelpTipW / 2, HelpTipH / 2);
		action(this);
	}
    HelpTip.onclick = function() {
		websys_showModal({
			url:'../scripts/DHCMA/HAI/Document/PDCA流程操作说明.pdf',
			title:$g('帮助文档'),
			iconCls:'icon-w-paper',     
			width:1200,
			height:window.screen.availHeight-80
		});
	}
	window.onresize = function () {
		var bodyH = document.body.offsetHeight;
		var nekoT = HelpTip.offsetTop;
		var bodyW = document.body.offsetWidth;
		var nekoL = HelpTip.offsetLeft;

		if (nekoT + HelpTipH > bodyH) {
			HelpTip.style.top = bodyH - HelpTipH + 'px';
			cuntH++;
		}
		if (bodyH > nekoT && cuntH > 0) {
			HelpTip.style.top = bodyH - HelpTipH + 'px';
		}
		if (nekoL + HelpTipW > bodyW) {
			HelpTip.style.left = bodyW - HelpTipW + 'px';
			cuntW++;
		}
		if (bodyW > nekoL && cuntW > 0) {
			HelpTip.style.left = bodyW - HelpTipW + 'px';
		}

		move(HelpTip, HelpTipW / 2, HelpTipH / 2);
	}
	
}


