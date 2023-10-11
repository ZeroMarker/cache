
//ҳ��Event
function InitWinEvent(obj){
	//�¼���ʼ��
	obj.LoadEvent = function(args){
		obj.gridDicTypeLoad();
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridDicType.getSelected()
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#winBtnEdit').on('click', function(){
			obj.Save();
		});
		$('#winBtnClose').on('click', function(){
			$HUI.dialog('#winEdit').close();
		});
		$('#searchbox').searchbox({ 
			searcher:function(value,name){
				searchText($("#gridDicType"),value);
			}	
		});
     }
    //˫���༭
	obj.gridDicType_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//ѡ��
	obj.gridDicType_onSelect = function (){
		var rowData = obj.gridDicType.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridDicType.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}

	//���ķ���-����
	obj.Save = function(){
		
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
	
		if (!Code) {
			errinfo = errinfo + "�ֵ����ʹ��벻����Ϊ��!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "�ֵ��������Ʋ�����Ϊ��!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return ;
		}
		var InputStr=obj.RecRowID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + $('#txtDataSource').combobox('getValue');
		var flg = $m({
			ClassName:"DHCHAI.DP.OperDataSource",
			MethodName:"Update",
			aInputStr:InputStr,
		},false);
		
		if (parseInt(flg)> 0) {
			obj.RecRowID = flg;
			obj.gridDicTypeLoad();	//ˢ�µ�ǰҳ
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("������ʾ", "�����ظ�!" , 'info');
		}else{
			$.messager.alert("������ʾ", "�޸�ʧ��!Error=" + flg, 'info');
		}
	}
	//���ķ���-ɾ��
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("��ʾ", "��ѡ������,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "ȷ���Ƿ�ɾ��?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.OperDataSource",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					obj.RecRowID = "";
					obj.gridDicTypeLoad();	//ˢ�µ�ǰҳ
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
				} else {
					if (parseInt(flg)=='-777') {
						$.messager.alert("��ʾ","-777����ǰ��ɾ��Ȩ�ޣ�������ɾ��Ȩ�޺���ɾ����¼!",'info');
					}else {
						$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					}
				}
			} 
		});
	}
	obj.gridDicTypeLoad=function(){
		originalData["gridDicType"]="";
		$cm({
			ClassName:"DHCHAI.DPS.OperDataSourceSrv",
			QueryName:"QryDataSourceType",
			page:1,
			rows:9999
		},function(rs){
			$('#gridDicType').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
		});
	}
    //����-��ʼ��
	obj.InitDialog= function(rd){
		console.log(rd)
		if(rd){
			$('#txtCode').val(rd["Code"]).validatebox("validate");
			$('#txtDesc').val(rd["Desc"]).validatebox("validate");
			$('#txtDataSource').combobox('setValue',rd["SourceCode"]);
			$('#txtDataSource').combobox('setText', rd["DataSource"]);
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtCode').val('').validatebox("validate");
			$('#txtDesc').val('').validatebox("validate");
			
			obj.RecRowID = "";
		}
		$("#winEdit").show()
		$('#winEdit').dialog({
			title: '����Դ���ͱ༭',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
}
