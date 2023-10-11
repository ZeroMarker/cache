$(function() {
    //loadImageList();
    if( isModify == "Y")
    {
		initData();    
	}
    
	$("#publicSave").click(function(){
		var nodeText = $("#nodeText").val();
		if (nodeText == "") {
			alert('请输入节点名称');	
			return
		}
		var content = document.getElementById("center").innerText;
		///转义双引号，不然后台方法会报错
		var content = content.replace(/\"/g, "&quot;");
		jQuery.ajax({
			type: "POST",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: true,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLTextKBContent",
				"Method":"NewData",
				"p1":nodeID,
				"p2":content,
				"p3":userCode,
				"p4":nodeText,
				"p5":isModify
			},
			success: function(d) {
				if (d !== "1") {
					alert('新增数据失败,失败代码'+d);
				}else {
					reloadTextKbTree();
					alert('已保存并自动审核');
					closeWindow();
				}
				//document.getElementById('content').innerHTML=d; 
			},
			error : function(d) { alert("NewData error");}
		});	
	});
});

function initData(){
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLTextKBContent",
			"Method":"GetContent",
			"p1":nodeID
		},
		success: function(d) {
			document.getElementById('center').innerHTML=d; 
		},
		error : function(d) { alert("GetContent error");}
	});	
	$("#nodeText").val(nodeName);
}


///清空文字
function hide() {
	if(document.getElementById("center").innerText=='输入内容...') document.getElementById("center").innerText="";
}

function reloadTextKbTree()
{
	if (typeof(para[3]) == "function"){
		para[3]();
	}
}

//关闭窗口
function closeWindow()
{
	window.opener = null;
	window.open('','_self');
	window.close();	
}