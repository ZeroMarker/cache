function showImage(e) {
	const img = new Image();
	img.src = e.src || e.getAttribute('src');
	const newWin = window.open("", "_blank","height=700,width=1100,toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1,top=50,left=50");
	newWin.document.write(img.outerHTML);
	newWin.document.title = "ͼƬ����"
	newWin.document.close();
}
function ZoomImage(e) {
	new imageZoom(e.id,{
		mul:6,//ָ���Ŵ�ı���
		viewerMul:2,
		viewerPos:{h:1,v:0},//��ʾ��ָ��λ��(Ĭ��ֵΪ��{h:10,v:0})��h:-10��ʾ���ƫ��10����
	onShow:function() {
	},
	onHide:function() {
	},
	bigImg:e.src //ָ���Ŵ�ͼƬ·��
	});
}
function DeletePic(e){
	//alert(e.id)
	var RowID=e.id;
	if(RowID==""){
		$.messager.alert('��ʾ',"ɾ��ʧ��,ͼƬ��Ϣ��ȡʧ��","warning");
		return false;	
	}else{
		var DCRPRowID=RowID.split("@")[1];
		$.messager.confirm('��ʾ',"�Ƿ�ȷ��ɾ��ͼƬ?",function(r){
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
						$.messager.alert('��ʾ',"ɾ��ʧ��,�������:"+ret,"warning");	
						return false;	
					}	
				})
			}
		})
	}
}