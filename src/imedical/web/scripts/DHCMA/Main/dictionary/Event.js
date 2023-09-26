function InitDictWinEvent(obj){
	//异常弹窗
	$("#winInit").dialog({
		title:"编辑",
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.btnSave_click();
				var selNode=$('#treeType').tree('getSelected');
				var par = $('#treeType').tree('getParent',selNode.target);
				$('#treeType').tree('reload',par.target);
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winInit').close();
			}
		}]
		
	});
	//event加载
	obj.LoadEvent=function(args){
		//树一级右键执行
		$("#btnAddType").on("click",obj.btnAddType_click) 
		//树二级右键执行
		$("#btnAddItem").on("click",obj.btnAddItem_click) 
		$("#btnEditType").on("click",obj.btnEditType_click) 
	}
	//右键添加类型
	obj.btnAddType_click=function(){
		obj.layInit("SYS","");
	}
	//右键编辑类型
	obj.btnEditType_click=function(){
		var valArr=obj.CurrNode.id.split("-");
		obj.layInit("SYS",valArr[2]);
		//打开弹窗		
	}
	//右键添加项目
	obj.btnAddItem_click=function(){
		var valArr=obj.CurrNode.id.split("-");
		obj.layInit(obj.CurrDicType,valArr[2]);
		
	}
	//双击表单
	obj.gridItems_onDbselect=function(rowData){
		//obj.layInit(rowData["Type"],rowData["myid"]);
		var productId=obj.ProductId;
		$('#cboHosp').combobox('enable');
		if(rowData["myid"]){
			//编辑
			var strDic=obj.GetStrDic(rowData["myid"])
			if(strDic == "")return;
			var arryFields = strDic.split("^");
			if (arryFields[8]!="undefined"){
				productId=arryFields[8];
			}
			$("#txtCode").val(arryFields[1]);
			$("#txtDesc").val(arryFields[2]);
			if(arryFields[4]!='0'){$("#cboHosp").combobox("setValue",arryFields[4]);}else{$("#cboHosp").combobox("setValue",session['LOGON.HOSPID']);}
			$('#cboHosp').combobox('disable');
			$("#cboPro").combobox("setValue",productId);
			$("#chkIsActive").checkbox("setValue",arryFields[5] == "1"?true:false);
			$("#txtRowId").val(arryFields[0]);
			$("#txtType").val(arryFields[3]);
		}
		$HUI.dialog('#winInit').open();
	};
	//字典项目保存事件
	obj.btnSave_click=function(){
		var code=$.trim($("#txtCode").val());
		var desc=$.trim($("#txtDesc").val());
		if(code=="") {
			$.messager.alert("提示","代码不能为空！");
			return;
		}
		if(desc=="") {
			$.messager.alert("提示","描述不能为空！");
			return;
		}	
		var rowId=$.trim($("#txtRowId").val());
		var type=$.trim($("#txtType").val());
		var hospital=$("#cboHosp").combobox("getValue")
		var product=$("#cboPro").combobox("getValue");
		if(product=="") {
			$.messager.alert("提示","所属产品不能为空！");
			return;
		}	
		var active =$("#chkIsActive").checkbox("getValue");
		var isActive=active?'1':'0';
		if(!type){type=obj.CurrDicType}
		var separete = String.fromCharCode(1);
		var tmp = rowId+ separete;
		tmp += code+ separete;
		tmp += desc + separete;
		tmp += type + separete;
		tmp += hospital + separete;
		tmp += isActive + separete;	
		tmp +=  separete;//开始时间
		tmp +=  separete;//结束时间
		tmp += product + separete;
		
		
		if(rowId!=""){
			var CKCode=$m({
				ClassName:'DHCMed.SS.Dictionary',
				MethodName:'CheckCode',
				aTypeCode:code,
				aCode:type				
			},false)//dicPersistent.CheckCode(obj.dicType,obj.Code.getValue())
			if(CKCode==1){
				$.messager.alert("提示","代码重复，请重新填写！");
				return;
			}
		}
		// fix bug 117305 先判断类别有效性再更新
		if((type != "SYS")&&(isActive == 1))
		{
			var retB = $m({
				ClassName:'DHCMed.SSService.DictionarySrv',
				MethodName:'CheckIsActive',
				atype:type,
			},false)//dicServer.CheckIsActive(obj.dicType);
			if(retB == 0)
			{
				$.messager.alert("提示","该字典项目所属的字典类别有效性为'No',请修改其有效性！");	
				return;
			}
		}
		/**
		//检验 字典类别的医院 和 字典项的医院 是否匹配
		console.log($("#treeType").tree("getSelected"));
		var DicItemRet = $m({
			ClassName:'DHCMed.SS.Dictionary',
			MethodName:'GetStringById',
			id:$("#treeType").tree("getSelected").id.split("-")[2],
			separete:"-",
			dataType:"text"
		},false)
		if(DicItemRet.split("-")[4] != $("#cboHosp").combobox("getValue"))
		{
			$.messager.alert("提示","请修改医院，保持和左侧选项的医院一致");
			return;
		}
		**/
		var ret =$m({
			ClassName:'DHCMed.SS.Dictionary',
			MethodName:'Update',
			InStr:tmp,
			separete:separete				
		},false) //dicPersistent.Update(tmp,separete);		
		if(ret<0) {
			if(ret == "-2")
				$.messager.alert("提示","输入的代码与列表中的项目代码重复！");
			else
				$.messager.alert("提示","保存失败！");
			return;
		}
		else{
			if((type == "SYS")&&(isActive == 0))
			{
				var retA = $m({
					ClassName:'DHCMed.SSService.DictionarySrv',
					MethodName:'ChangeIsActive',
					acode:code
				},false);//dicServer.ChangeIsActive(obj.Code.getValue());
				if(retA > 0) $.messager.alert("提示","该字典类别下所有字典项目的有效性已置为'No'！");
			}
			
			var arryField = obj.CurrNode.id.split("-");
				obj.gridItems.load({
				 ClassName:"DHCMed.SSService.DictionarySrv",
				QueryName:"QryDictionary",
				aType:arryField[1],
				aIsActive:''
			});
			
			$HUI.dialog('#winInit').close();	
				
			if(type == "SYS")
			{
				obj.refreshNode(obj.CurrNode);
			}
		}
	};



	//只要一个弹窗 
	obj.layInit=function(){
		var productId=obj.ProductId
		var DicType=obj.CurrDicType
		$('#cboHosp').combobox('enable');
		if(arguments[1]){
			//编辑
			var strDic=obj.GetStrDic(arguments[1])
			if(strDic == "")return;
			var arryFields = strDic.split("^");
			if (arryFields[8]!="undefined"){
				productId=arryFields[8];
			}
			//编辑添加项目
			if(arguments[0]==DicType){
				$("#txtCode").val("");
				$("#txtDesc").val("");
				if(arryFields[4]!='0'){$("#cboHosp").combobox("setValue",arryFields[4]);}else{$("#cboHosp").combobox("setValue",session['LOGON.HOSPID']);}
				$('#cboHosp').combobox('disable');
				$("#cboPro").combobox("setValue",productId);
				$("#chkIsActive").checkbox("setValue",false);
				$("#txtRowId").val("");
				$("#txtType").val(arguments[0]);
				$HUI.dialog('#winInit').open();
				return;
				}
			$("#txtCode").val(arryFields[1]);
			$("#txtDesc").val(arryFields[2]);
			if(arryFields[4]!='0'){$("#cboHosp").combobox("setValue",arryFields[4]);}else{$("#cboHosp").combobox("setValue",session['LOGON.HOSPID']);}
			$('#cboHosp').combobox('disable');
			$("#cboPro").combobox("setValue",productId);
			$("#chkIsActive").checkbox("setValue",arryFields[5] == "1"?true:false);
			$("#txtRowId").val(arryFields[0]);
			$("#txtType").val(arryFields[3]);
		}else{
			//添加
			//$("#txtCode").attr("disable",true)
			$("#txtCode").val("");
			$("#txtDesc").val("");
			$("#cboHosp").combobox("setValue",session['LOGON.HOSPID']);
			$("#cboPro").combobox("setValue",productId);
			$("#chkIsActive").checkbox("setValue",false);
			$("#txtRowId").val(arguments[1]);
			$("#txtType").val(arguments[0]);
		}
		$HUI.dialog('#winInit').open();
	}
}