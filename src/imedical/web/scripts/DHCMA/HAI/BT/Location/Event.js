//页面Event
function InitWinEvent(obj){
	//选择
	obj.gridLocation_onSelect = function (){
		var rowData = obj.gridLocation.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnSyn").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnVirtual").linkbutton("disable");
			$("#btnLocLink").linkbutton("disable");
			obj.gridLocation.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnSyn").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnVirtual").linkbutton("enable");
			$("#btnLocLink").linkbutton("enable");
		}
	}
	obj.gridLocLink_onSelect=function(){
		var rowData = obj.gridLocLink.getSelected();
		if (rowData["RowID"] == obj.LinkRowID) {
			obj.LinkRowID="";
			$("#btnAddLink").linkbutton("enable");
			$("#btnEditLink").linkbutton("disable");
			$("#btnDeleteLink").linkbutton("disable");
			obj.gridLocLink.clearSelections();
		} else {
			obj.LinkRowID = rowData["RowID"];
			$("#btnAddLink").linkbutton("disable");
			$("#btnEditLink").linkbutton("enable");
			$("#btnDeleteLink").linkbutton("enable");
			
		}
	}
	obj.gridLocation_onDblClickRow=function(rd){
		obj.layer_Edit_Open(rd);
		
	}
	//事件初始化
	obj.LoadEvent = function(args){
		obj.gridLocationLoad();
		
		$('#btnSyn').on('click', function(){
			obj.btnSyn_Click();
		});
		$('#btnEdit').on('click', function(){
			var rd = obj.gridLocation.getSelected();
			obj.layer_Edit_Open(rd);	
		});
		
		$('#btnVirtual').on('click', function(){
			obj.layer_Virtual_Open();
		});
		$('#btnLocLink').on('click', function(){
			obj.layer_LocLink_Open();
		});
		$('#btnAddLink').on('click', function(){
			obj.AddLink();
		});
		$('#btnEditLink').on('click', function(){
			var rowData=obj.gridLocLink.getSelected();
			if (!rowData){
				return;
			}
			obj.EditLink(rowData)
		});
		$('#btnDeleteLink').on('click', function(){
			obj.DelLink();
		});
		$('#searchbox').searchbox({ 
			searcher:function(value,name){
				searchText($("#gridLocation"),value);
			}	
		});
		$HUI.combobox("#cboHospital",{
			onSelect:function(Data){
				obj.gridLocationLoad();
			}
		})
     }
	// 同步
	obj.btnSyn_Click=function(){
		if (!$.LOGON.HISCode) {
			$.messager.alert("简单提示", "HIS系统代码为空", "error");	
			return;
		}
		var retval = $m({
			ClassName:"DHCHAI.DI.DHS.SyncHisInfo",
			MethodName:"SyncLocation",
			aSCode:$.LOGON.HISCode,
			aHospCode:"", 
			aUserID:$.LOGON.USERID
		},false);
		if (parseInt(retval)>0){
			$.messager.alert("简单提示", "科室列表同步成功.", "success");	
		} else {
			$.messager.alert("简单提示", "科室列表同步失败!", "error");	
		}
		obj.gridLocationLoad();
	}
	// 加载（前台）分页
	obj.gridLocationLoad = function(){
		originalData["gridLocation"]="";
		$cm ({
		    ClassName:"DHCHAI.BTS.LocationSrv",
			QueryName:"QryLoc",
			aHospIDs:$('#cboHospital').combobox("getValue"),
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridLocation').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
			if ($('#searchbox').searchbox('getValue')) {
				searchText($("#gridLocation"),$('#searchbox').searchbox('getValue'));
			}				
		});
    }
	// 修改
	obj.layer_Edit_Open=function(rd){
		
		if (!rd){
			return;
		}
		if (rd){
			$("#txtLocCode").val(rd["LocCode"]);
			$("#txtLocDesc").val(rd["LocDesc"]);
			$("#txtLocDesc2").val(rd["LocDesc2"]);
			$("#cboLocType").combobox('setValue',rd["LocTypeDr"]) //,rd["LocTypeDesc"]);
			$("#cboLocCate").combobox('setValue',rd["LocCateDr"]) //,rd["LocCateDesc"]);
			$("#cboLocGroup").combobox('setValue',rd["GroupDr"])  //,rd["GroupDesc"]);
			$("#cboLocHosp").combobox('setValue',rd["HospDr"])   //,rd["HospDesc"]);
			$("#cboLocICUType").combobox('setValue',rd["ICUTpDr"]) //,rd["ICUTpDesc"]);
			$("#cboLocType").combobox('setText',rd["LocTypeDesc"]);
			$("#cboLocCate").combobox('setText',rd["LocCateDesc"]);
			$("#cboLocGroup").combobox('setText',rd["GroupDesc"]);
			$("#cboLocHosp").combobox('setText',rd["HospDesc"]);
			$("#cboLocICUType").combobox('setText',rd["ICUTpDesc"]);
			$('#chkIsICU').checkbox('setValue',(rd["IsICU"]=='是' ? true : false));
			$('#chkIsNICU').checkbox('setValue',(rd["IsNICU"]=='是' ? true : false));
			$('#chkIsOPER').checkbox('setValue',(rd["IsOPER"]=='是' ? true : false));
			$('#chkIsActive').checkbox('setValue',(rd["IsActive"]=='是' ? true : false));
			$('#txtIndNo').val(rd["IndNo"]);							   
		} else {
			$("#txtLocCode").val('');
			$("#txtLocDesc").val('');
			$("#txtLocDesc2").val('');
			$("#cboLocType").combobox('setValue','');
			$("#cboLocCate").combobox('setValue','');
			$("#cboLocGroup").combobox('setValue','');
			$("#cboLocHosp").combobox('setValue','');
			$("#cboLocICUType").combobox('setValue',"") //,rd["ICUTpDesc"]);
			$('#chkIsICU').checkbox('setValue',false);
			$('#chkIsNICU').checkbox('setValue',false);
			$('#chkIsOPER').checkbox('setValue',false);
			$('#chkIsActive').checkbox('setValue',false);
			$('#txtIndNo').val("");		
		}
		
		$('#winLocEdit').show();
		$('#winLocEdit').dialog({
			title: "科室信息编辑",
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.Layer_Save1(rd);
				}
			},{
			text:'关闭',
				handler:function(){
					$HUI.dialog('#winLocEdit').close();

				}
			}]
		});
		
	}
	// 保存修改
	obj.Layer_Save1 = function(rd){
		//var rd = obj.gridLocation.getSelected();
		if (!rd) {
			return;
		}
		var ID = (rd ? rd["ID"] : '');
		var XCode = (rd ? rd["XCode"] : '');
		var ParLocDr = (rd ? rd["ParLocDr"] : '');
		
		
		var LocCode = $("#txtLocCode").val();
		var LocDesc = $("#txtLocDesc").val();
		var LocDesc2 = $("#txtLocDesc2").val();
		var LocType = $("#cboLocType").combobox("getValue");
		var LocCate = $("#cboLocCate").combobox("getValue");
		var LocGroup = $("#cboLocGroup").combobox("getValue");
		var LocHosp = $("#cboLocHosp").combobox("getValue");
		var IsICU = ($("#chkIsICU").checkbox('getValue')? 1 : 0);
		var IsNICU = ($("#chkIsNICU").checkbox('getValue')? 1 : 0);
		var IsOPER = ($("#chkIsOPER").checkbox('getValue')? 1 : 0);
		var LocICUType = $("#cboLocICUType").combobox('getValue');
		var IsActive = ($("#chkIsActive").checkbox('getValue')? 1 : 0);
		var ActUserDr = $.LOGON.USERID;
		var IndNo = $("#txtIndNo").val();	
		
		if (LocCode == '') {
			$.messager.alert("简单提示", "科室代码不允许为空！", "info");	
			return;
		}
		if (LocDesc == '') {
			$.messager.alert("简单提示", "科室名称不允许为空！", "info");	
			return;
		}
		if (LocHosp == '') {
			$.messager.alert("简单提示", "科室所属院区不允许为空！", "info");	
			return;
		}
		if ((IsICU==1)&&(IsNICU==1)) {
			$.messager.alert("简单提示", "科室不能同时属于重症病房(ICU)和新生儿病房(NICU)！", "info");	
			return;
		}
		var InputStr = ID;
		InputStr += "^" + LocCode;
		InputStr += "^" + LocDesc;
		InputStr += "^" + LocDesc2;
		InputStr += "^" + LocType;
		InputStr += "^" + LocCate;
		InputStr += "^" + LocGroup;
		InputStr += "^" + LocHosp;
		InputStr += "^" + IsOPER;
		InputStr += "^" + IsICU;
		InputStr += "^" + IsNICU;
		InputStr += "^" + LocICUType;
		InputStr += "^" + XCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		InputStr += "^" + ParLocDr;
		InputStr += "^" + IndNo;
		var retval = $m({
			ClassName:"DHCHAI.BT.Location",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		if (parseInt(retval)>0){
			$.messager.popover({msg: '保存成功.',type:'success',timeout: 1000});
			$HUI.dialog('#winLocEdit').close();
			obj.gridLocationLoad();
		} else {
			if(parseInt(retval)=='-2'){
				$.messager.alert("简单提示", "代码重复!", "error");	
			}else {
				$.messager.alert("简单提示", "保存失败!", "error");	
			}
		}
	}
	// 虚拟病区
	obj.layer_Virtual_Open=function(){
		var rd = obj.gridLocation.getSelected();
		if (!rd) {
			return;
		}
		if (rd){
			var LocTypeDesc=rd["LocTypeDesc"];
			var LocCateDesc=rd["LocCateDesc"];
			if ((LocTypeDesc.indexOf("病区")<0)||(LocCateDesc.indexOf("住院")<0)){
				$.messager.alert("简单提示", "非住院病区,不允许虚拟病区!", "info");	
				return;
			}
			$("#txtLocCode").val(rd["LocCode"]);
			$("#txtLocDesc").val(rd["LocDesc"]);
			$("#txtLocDesc2").val(rd["LocDesc2"]+'虚拟病区');
			$("#cboLocType").combobox('setValue',rd["LocTypeDr"]) 
			$("#cboLocCate").combobox('setValue',rd["LocCateDr"]) 
			$("#cboLocGroup").combobox('setValue',rd["GroupDr"])  
			$("#cboLocHosp").combobox('setValue',rd["HospDr"])   
			$("#cboLocICUType").combobox('setValue',rd["ICUTpDr"]) 
			$("#cboLocType").combobox('setText',LocTypeDesc);
			$("#cboLocCate").combobox('setText',LocCateDesc);
			$("#cboLocGroup").combobox('setText',rd["GroupDesc"]);
			$("#cboLocHosp").combobox('setText',rd["HospDesc"]);
			$("#cboLocICUType").combobox('setText',rd["ICUTpDesc"]);
			$('#chkIsICU').checkbox('setValue',(rd["IsICU"]=='是' ? true : false));
			$('#chkIsNICU').checkbox('setValue',(rd["IsNICU"]=='是' ? true : false));
			$('#chkIsOPER').checkbox('setValue',(rd["IsOPER"]=='是' ? true : false));
			$('#chkIsActive').checkbox('setValue',(rd["IsActive"]=='是' ? true : false));
			$('#txtIndNo').val(rd["IndNo"]);
	
			$('#winLocEdit').show();
		
			$('#winLocEdit').dialog({
				title: "虚拟病区信息编辑",
				iconCls:'icon-w-paper',
				modal: true,
				isTopZindex:true,
				buttons:[{
					text:'保存',
					handler:function(){
						obj.layer_Save2()
					}
				},{
				text:'关闭',
					handler:function(){$HUI.dialog('#winLocEdit').close();}
				}]
			});
		}
	}
		//保存虚拟病区
	obj.layer_Save2=function(){
		var rd = obj.gridLocation.getSelected();
		if (!rd) {
			return;
		}
		
		var ParLocDr = (rd ? rd["ID"] : '');
		var XCode = (rd ? rd["XCode"] : '');
		
		var LocCode = $("#txtLocCode").val();
		var LocDesc = $("#txtLocDesc").val();
		var LocDesc2 = $("#txtLocDesc2").val();
		var LocType = $("#cboLocType").combobox("getValue");
		var LocCate = $("#cboLocCate").combobox("getValue");
		var LocGroup = $("#cboLocGroup").combobox("getValue");
		var LocHosp = $("#cboLocHosp").combobox("getValue");
		var IsICU = ($("#chkIsICU").checkbox('getValue')? 1 : 0);
		var IsNICU = ($("#chkIsNICU").checkbox('getValue')? 1 : 0);
		var IsOPER = ($("#chkIsOPER").checkbox('getValue')? 1 : 0);
		var LocICUType = $("#cboLocICUType").combobox('getValue');
		var IsActive = ($("#chkIsActive").checkbox('getValue')? 1 : 0);
		var ActUserDr = $.LOGON.USERID;
		var IndNo = $("#txtIndNo").val();	
		
		if (LocCode == '') {
			$.messager.alert("简单提示", "科室代码不允许为空！", "info");	
			return;
		}
		if (LocDesc == '') {
			$.messager.alert("简单提示", "科室名称不允许为空！", "info");	
			return;
		}
		if (LocHosp == '') {
			$.messager.alert("简单提示", "科室所属院区不允许为空！", "info");	
			return;
		}
		if ((IsICU==1)&&(IsNICU==1)) {
			$.messager.alert("简单提示", "科室不能同时属于重症病房(ICU)和新生儿病房(NICU)！", "info");	
			return;
		}
		var InputStr = "";
		InputStr += "^" + LocCode;
		InputStr += "^" + LocDesc;
		InputStr += "^" + LocDesc2;
		InputStr += "^" + LocType;
		InputStr += "^" + LocCate;
		InputStr += "^" + LocGroup;
		InputStr += "^" + LocHosp;
		InputStr += "^" + IsOPER;
		InputStr += "^" + IsICU;
		InputStr += "^" + IsNICU;
		InputStr += "^" + LocICUType;
		InputStr += "^" + XCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		InputStr += "^" + ParLocDr;
		InputStr += "^" + IndNo;
		
		var retval = $m({
			ClassName:"DHCHAI.BT.Location",
			MethodName:"Update2",
			aInputStr:InputStr
		},false);
		if (parseInt(retval)>0){
			$.messager.popover({msg: '保存成功.',type:'success',timeout: 1000});
			$HUI.dialog('#winLocEdit').close();
			obj.gridLocationLoad();
		} else {
			if(parseInt(retval)=='-2'){
				$.messager.alert("简单提示", "已添加过虚拟病区,不可重复!", "error");	
				$HUI.dialog('#winLocEdit').close();
				obj.gridLocationLoad();
			}else {
				$.messager.alert("简单提示", "保存失败!", "error");	
			}
		}
	}
	// 关联科室
	obj.layer_LocLink_Open=function(){
		var rd = obj.gridLocation.getSelected();
		if (!rd) {
			return;
		}
		obj.LinkID=rd["ID"]
		obj.gridLocLink.load({
			ClassName:"DHCHAI.BTS.LocationSrv",
			QueryName:"QryLocLink",
			aLocID:(typeof(obj.LinkID)=='undefined'?'':obj.LinkID)
		});
		$('#wingridLocLink').show();
		$('#wingridLocLink').dialog({
			title: "关联科室",
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true,
			buttons:[{
			text:'关闭',
				handler:function(){$HUI.dialog("#wingridLocLink").close();}
			}]
		});
	}
	//窗体
	obj.SetDiaglog=function (Item,Title){
		return $('#'+Item).dialog({
			title: Title,
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'保存',
				handler:function(){}
			},{
			text:'关闭',
				handler:function(){$HUI.dialog('#'+Item).close();}
			}]
		});
	}

	obj.AddLink=function(){
		if (obj.LinkLocTypeCode=='E'){
			var LocType ="W"
		}else if(obj.LinkLocTypeCode=='W'){
			var LocType ="E"
		}else{
			var LocType =""
		}
		$("#cboLocation").combobox('setValue',"");
		$('#winLocLinkEdit').show();
		Common_ComboToLoc("cboLocation",obj.LinkHosp,"","I|E",LocType)
		
		obj.LinkRowID="";
		$('#winLocLinkEdit').dialog({
			title: "新增关联科室",
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'新增',
				handler:function(){
					obj.LayerEditLink_Save();
				}
			},{
			text:'关闭',
				handler:function(){$HUI.dialog("#winLocLinkEdit").close();}
			}]
		});

	}
	obj.EditLink=function(rd){
		if (obj.LinkLocTypeCode=='E'){
			var LocType ="W"
		}else if(obj.LinkLocTypeCode=='W'){
			var LocType ="E"
		}else{
			var LocType =""
		}
		$('#winLocLinkEdit').show();
		Common_ComboToLoc("cboLocation",obj.LinkHosp,"","I|E",LocType)
		$("#cboLocation").combobox('setValue',rd['LinkLocID']);
		$("#cboLocation").combobox('setText',rd['LinkLocDesc2']);
		obj.LinkRowID=rd['RowID'];
		$('#winLocLinkEdit').dialog({
			title: "关联科室修改",
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'修改',
				handler:function(){
					obj.LayerEditLink_Save();
				}
			},{
			text:'关闭',
				handler:function(){$HUI.dialog("#winLocLinkEdit").close();}
			}]
		});
		
	}
	obj.LayerEditLink_Save = function(){
		var LinkLocID = $("#cboLocation").combobox("getValue");
		if (LinkLocID==''){
			$.messager.alert("简单提示", "请选择关联科室！", "info");	
			return;
		}
		InputStr = (typeof(obj.LinkRowID)=='undefined'?'':obj.LinkRowID);
		InputStr += "^" + obj.LinkID;
		InputStr += "^" + LinkLocID;
		InputStr += "^" + 1;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
	
		var retval =$m({
			ClassName:"DHCHAI.BT.LocationLink",
			MethodName:"Update",
			aInputStr:InputStr
		},false); 
		if (parseInt(retval)>0){
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
			obj.gridLocLink.reload();
		} else {
			$.messager.alert("简单提示", "保存失败!", "error");	
			
		}
	}
	obj.DelLink=function(){
		var rd=obj.gridLocLink.getSelected();
		if (!rd){
			return;
		}
		
		var ID = rd["RowID"];
		$.messager.confirm("删除", "确定删除选中的记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.BT.LocationLink",
					MethodName:"DeleteById",
					aId:ID
				},false);
				if (flg == '0'){
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.LinkRowID="";
					obj.gridLocLink.reload();
				} else {
					$.messager.alert("提示","删除失败!",'info');
				}
			} 
		});	
	
	}
}
