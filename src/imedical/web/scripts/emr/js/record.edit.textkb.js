$(function() {
    //loadImageList();
	$("#publicSave").click(function(){
		var nodeText = $("#nodeText").val();
		if (nodeText == "") {
			alert('请输入节点名称');	
			return
		}
		var content = document.getElementById("center").innerText;
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
				"p4":nodeText
			},
			success: function(d) {
				if (d !== "1") {
					alert('新增数据失败,失败代码'+d);
				}else {
					alert('已保存并自动审核,请刷新列表后查看');
					closeWindow();
				}
				//document.getElementById('content').innerHTML=d; 
			},
			error : function(d) { alert("NewData error");}
		});	
	});
});

///清空文字
function hide() {
	if(document.getElementById("center").innerText=='输入内容...') document.getElementById("center").innerText="";
}


//关闭窗口
function closeWindow()
{
	window.opener = null;
	window.open('','_self');
	window.close();	
}