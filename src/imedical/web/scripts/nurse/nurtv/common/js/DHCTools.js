function getAbsPosition(item) {
	var actualLeft = item.offsetLeft;
	var actualTop = item.offsetTop;
	var current = item.offsetParent;
	while (current !== null) {
		actualLeft += (current.offsetLeft + current.clientLeft);
		actualTop += (current.offsetTop + current.clientTop);
		current = current.offsetParent;
	}
	return {
		'left': actualLeft,
		'top': actualTop
	};
}


function dealNamePrivate(str) {
	if (!str || str == '') {
		return '';
	}
	str = str + '';
	if (str.length == 1) {
		return str;
	}
	if (localStorage['namePrivate'] != 'true') {
		mui('.patDetail .important').each(function (index,element) {
			element.classList.remove('hide');
		});
		return str;
	}
	mui('.patDetail .important').each(function (index, element) {
		element.classList.add('hide');
	});
	if (str.length == 2) {
		return str.substr(0, 1) + '*';
	} else {
		str = str.substr(0, 1) + '*' + str.substring(2, str.length);
		return str;
	}
}

function setcookie(key, value, day) {
	//创建时间对象 设置cookie过期时间
	var date = new Date();
	date.setDate(date.getDate() + day);
	//设置cookie
	document.cookie = key + "=" + escape(value) + ";expires=" + date;
}

function getcookie(key) {
	var coo = unescape(document.cookie);
	//split 是通过查找一个字符 然后把前面和后面的内容组合成一个数组
	var arr = coo.split("; ");
	//[user1=xiaoming,user2=xiaoli]
	for (i = 0; i < coo.length; i++) {
		var arr2 = arr[i].split("=")
		if (arr2[0] == key) {
			return arr2[1];
		}
	}
}

function removecookie(key) {
	setcookie(key, "0", -1); //在当前时间里减1天
}

// 根据某一字段进行json排序
function jsonSort(array, field, reverse) {
	//数组长度小于2 或 没有指定排序字段 或 不是json格式数据
	if (array.length < 2 || !field || typeof array[0] !== "object") return array;
	//数字类型排序
	if (typeof array[0][field] === "number") {
		array.sort(function(x, y) {
			return x[field] - y[field]
		});
	}
	//字符串类型排序
	if (typeof array[0][field] === "string") {
		array.sort(function(x, y) {
			return x[field].localeCompare(y[field])
		});
	}
	//倒序
	if (reverse) {
		array.reverse();
	}
	return array;
}


function showNULLByElementId(eleID, textStr,type) {
	if (!eleID) {
		return null;
	}
	var ele = document.getElementById(eleID);
	if (!ele) {
		return null;
	}
	ele.style.display = 'block';
	if(textStr && textStr != ''){
		ele.querySelector('.nullTip').innerText = textStr;
	}else{
		ele.querySelector('.nullTip').innerText = '没有查询到数据';
	}
	if (type == 'error') {
		ele.querySelector('.nullImage').style.backgroundImage = 'url(../common/images/404.png)';
	}else{
		ele.querySelector('.nullImage').style.backgroundImage = 'url(../common/images/null.png)';
	}
}

function hiddenNULLByElementId(str) {
	if (!str) {
		return null;
	}
	var ele = document.getElementById(str);
	if (!ele) {
		return null;
	}
	ele.style.display = 'none';
}

//谷歌浏览器和IE浏览器对鼠标滚轮的监听
function mouseWheelScroll(domId,e){
	var y = mui('#'+domId).scroll().y;
	var dom = document.getElementById(domId);
	var maxScrollY = dom.clientHeight - dom.querySelector('.mui-scroll').clientHeight;
	if (maxScrollY >= 0) {
		maxScrollY = 0
		return;
	}
	//判断浏览器IE，谷歌滑轮事件
	if (e.wheelDelta) {
		var tempY = 50;
		if (e.wheelDelta < 0) {
			tempY = -50;
		}
		y += tempY;
	}
	if (y > 50) {
		y = 50;
	}else if (y < maxScrollY - 50) {
		y = maxScrollY - 50;
	}
	mui('#'+domId).scroll().scrollTo(0,y,100);
	mui('#'+domId).scroll().reLayout();
}

//滚动到顶部

function wrapperScrollToTop(wrapperId){
	mui('#'+wrapperId).scroll().scrollTo(0,0,100);
}
//滚动到底部
function wrapperScrollToBottom(wrapperId){
	var dom = document.getElementById(wrapperId);
	var maxScrollY = dom.clientHeight - dom.querySelector('.mui-scroll').clientHeight;
	if (maxScrollY >= 0) {			
		return;
	}
	mui('#'+wrapperId).scroll().scrollTo(0,maxScrollY,100);
	mui('#'+wrapperId).scroll().reLayout();
}
// 检验非法字符
function checkIsHasSpecialStr(str,isNormalSave){
	var myReg = /[`~!@#$%^&*_+<>{}\/'[\]]/im;
	if (isNormalSave) {
		myReg = /[&<]/im;//无法保存到服务器的只有&<
	}
	if(myReg.test(str)) {
		// console.log(myReg);
		// console.log(str);
    	return true;
	}
	return false; 
}

function isArrEqual(arrA,arrB){
	if (arrA.length != arrB.length) {
		return false
	}
	for (var i = 0; i < arrA.length;i++) {
		var dictA = arrA[i];
		var dictB = arrB[i];
		for (var key in dictA) {
			if (dictA[key] != dictB[key]) {
				return false
			}
		}
	}
	return true
}