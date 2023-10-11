/**
 * 西医编目首页信息
 * 
 * Copyright (c) 2018-2022 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */
var globalObj = {
}

// 页面入口
$(function(){
	$('#btnPrint').click(function(){
		var iframe = document.createElement('iframe');
		iframe.setAttribute('style', 'position:absolute;width:0px;height:0px;left:500px;top:500px;')
		document.body.appendChild(iframe)
		doc = iframe.contentWindow.document;
		let wrap = document.getElementById("frontpage").innerHTML;
		doc.write("<div>" + wrap + "</div>");
		doc.close();
		iframe.contentWindow.focus();
		iframe.contentWindow.print();
	});
})
