﻿/*
 * 
 * 创建人：石萧伟
 * 创建时间：2018年7月18日
 * 创建说明：页面加载（loading）效果
 * 
*/
	//获取浏览器页面可见高度和宽度
	var _PageHeight = document.documentElement.clientHeight,
	    _PageWidth = document.documentElement.clientWidth;
	//计算loading框距离顶部和左部的距离（loading框的宽度为215px，高度为61px）
	var _LoadingTop = _PageHeight > 61 ? (_PageHeight - 61) / 2 : 0,
	    _LoadingLeft = _PageWidth > 215 ? (_PageWidth - 215) / 2 : 0;
	//在页面未加载完毕之前显示的loading Html自定义内容
	var _LoadingHtml = '<div id="loadingDiv" style="position:absolute;left:0;width:100%;height:' + _PageHeight + 'px;top:0;background:#fff;opacity:1;filter:alpha(opacity=80);z-index:10000;"><div style="position: absolute; cursor1: wait; left: ' + _LoadingLeft + 'px; top:' + _LoadingTop + 'px; width: auto; height: 57px; line-height: 57px; padding-left: 50px; padding-right: 50px; background:url(../scripts/bdp/Framework/icons/mkb/page_loading.gif) no-repeat scroll 5px 10px; "></div></div>';
	//呈现loading效果
	document.write(_LoadingHtml);
	 
	//window.onload = function () {
	//    var loadingMask = document.getElementById('loadingDiv');
	//    loadingMask.parentNode.removeChild(loadingMask);
	//};
	 
	//监听加载状态改变
	document.onreadystatechange = completeLoading;
	 
	//加载状态为complete时移除loading效果
	function completeLoading() {
	    if (document.readyState == "complete") {
	        var loadingMask = document.getElementById('loadingDiv');
	        loadingMask.parentNode.removeChild(loadingMask);
	    }
	}