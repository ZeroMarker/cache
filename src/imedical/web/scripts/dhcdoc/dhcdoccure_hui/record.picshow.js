function showImage(e) {
	const img = new Image();
	img.src = e.src || e.getAttribute('src');
	const newWin = window.open("", "_blank","height=700,width=1100,toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1,top=50,left=50");
	newWin.document.write(img.outerHTML);
	newWin.document.title = "图片详情"
	newWin.document.close();
}
function ZoomImage(e) {
	new imageZoom(e.id,{
		mul:6,//指定放大的倍数
		viewerMul:2,
		viewerPos:{h:1,v:0},//显示到指定位置(默认值为：{h:10,v:0})，h:-10表示左边偏移10像素
	onShow:function() {
	},
	onHide:function() {
	},
	bigImg:e.src //指定放大图片路径
	});
}
function DeletePic(e){
	//alert(e.id)
	var RowID=e.id;
	if(RowID==""){
		$.messager.alert('提示',"删除失败,图片信息获取失败","warning");
		return false;	
	}else{
		var DCRPRowID=RowID.split("@")[1];
		$.messager.confirm('提示',"是否确认删除图片?",function(r){
			if (r){
				var ret=$.cm({
					ClassName:"DHCDoc.DHCDocCure.Record",
					MethodName:"DelRecordPic",
					'DCRPRowID':DCRPRowID.replace(/-/g,"||"),
					'UserID':session['LOGON.USERID'],
					dataType:"text"
				},function(ret){
					if(ret==0){
						//window.location.reload();
						var par_li=$("#"+DCRPRowID).parent("li");
						par_li.remove();
					}else if(ret==100){
						if(websys_showModal('options')){
							websys_showModal('options').CureRecordDataGridLoad();
						}	
						websys_showModal("close");
					}else{
						$.messager.alert('提示',"删除失败,错误代码:"+ret,"warning");	
						return false;	
					}	
				})
			}
		})
	}
}