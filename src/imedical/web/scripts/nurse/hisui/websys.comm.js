/**
* @param {String} tableName
* @param {String} sessionStr default=""
* @param {Object} opt  {width:350,defaultValue:session['LOGON.HOSPID']}
*/
var _BDPHOSPCLS="web.DHCBL.BDP.BDPMappingHOSP";
function GenHospComp(tableName,sessionStr,opt){
	tableName = tableName||"";
	sessionStr = sessionStr||"";
	var hospid = (session&&session['LOGON.HOSPID'])||"";
	var defaultOpt = {width:350};
	opt = $.extend(defaultOpt,opt||{});
	if ($("#_HospList").length==0){
		$("<input id=\"_HospList\" class=\"textbox\"/>").prependTo("body");
	}
	if ($("#_HospListLabel").length==0){
		$("<label id='_HospListLabel' style='color:red;margin:0 10px 0 10px' class='r-label'>医院</label>").prependTo("body");
	}
	var defHospId = $cm({dataType:'text',ClassName:_BDPHOSPCLS,MethodName:"GetDefHospIdByTableName",tableName:tableName,HospID:hospid},false);
	var obj = $HUI.combogrid('#_HospList',{
		delay: 500,
		blurValidValue:true,
		panelWidth:350,
		width:opt.width,
		mode: 'remote',
		editable:false,
		pagination:true,
		lazy:true,
		minQueryLen:1,
		value:defHospId,
		isCombo:true,
		showPageList:false,
		showRefresh:false,
		displayMsg:"当前:{from}~{to},共{total}条",
        onBeforeLoad:function(param){
			param = $.extend(param,{desc:$("#_HospList").lookup("getText")});
			return true;
		},
		queryParams:{ClassName:_BDPHOSPCLS,QueryName:'GetHospDataForCombo',tablename:tableName,SessionStr:sessionStr},
		url: $URL,
		idField: 'HOSPRowId',
		textField: 'HOSPDesc',
		columns: [[
			{field:"HOSPRowId",title:"HOSPRowId",align:"left",hidden:true,width:100},
			{field:"HOSPDesc",title:"医院名称",align:"left",width:300}
		]]
	});
	return obj;
}

function GenHospWin(objectName,objectId,callback,opt){
	if ($("#_HospListWin").length==0){
		$("<div id=\"_HospListWin\" />").prependTo("body");
	}
	var singleSelect = false;
	if (opt){
		singleSelect = opt.singleSelect||false;
	}
	var gridObj = "";
	var obj = $HUI.dialog('#_HospListWin',{
		width:550,
		modal:true,
		height:350,
		title:'医院权限分配',
		content:'<table id="_HospListGrid"></table>',
		buttons:[{
			text:'确定',
			handler:function(){
				var HospIDs = "";
				var rows = gridObj.getData().rows;
				var checkRow = gridObj.getChecked();
				if (rows.length>0){
					for(var i=0;i<rows.length;i++){
						if ($.hisui.indexOfArray(checkRow,"HOSPRowId",rows[i]["HOSPRowId"])==-1){
							HospIDs +="^"+rows[i]["HOSPRowId"]+"$N"; 
						}else{
							HospIDs +="^"+rows[i]["HOSPRowId"]+"$Y";
						}
					}
				}
				//保存医院关联
				$cm({
					ClassName:_BDPHOSPCLS,
					MethodName:"UpdateHOSP",
					tableName:objectName,
					dataid:objectId,
					HospIDs:HospIDs,
					dataType:'text'
				},function(rtn){
					if(rtn==1){
						if ("function" == typeof callback) callback(checkRow);
						$HUI.dialog("#_HospListWin").close();
					}else{
						if (rtn.split("^").length>0){
							$.messager.popover({msg:rtn.split("^")[1],type:'alert',timeout: 2000});
						}else{
							$.messager.popover({msg:rtn,type:'alert',timeout: 2000});
						}
					}
				});
				
			}
		},{
			text:'取消',
			handler:function(){
				$HUI.dialog("#_HospListWin").close();
			}
		}],
		onOpen:function(){
			gridObj = $HUI.datagrid("#_HospListGrid",{
				mode: 'remote',
				fit:true,
				border:false,
				pagination:false,
				showPageList:false,
				showRefresh:false,
				singleSelect:singleSelect,
				queryParams:{ClassName:_BDPHOSPCLS,QueryName: 'GetHospDataForCloud',tablename:objectName,dataid:objectId},
				url: $URL,
				columns: [[
					{field:"LinkFlag",title:"授权情况",align:"center",width:100,checkbox:true},
					{field:"HOSPRowId",title:"HOSPRowId",align:"left",hidden:true,width:100},
					{field:"HOSPDesc",title:"医院名称",align:"left",width:300},
					{field:"MappingID",title:"ObjectId",align:"left",hidden:true,width:100}
				]],
				onLoadSuccess:function(row){               
		                var rowData = row.rows;
		                $.each(rowData,function(idx,val){
		                      if(val.LinkFlag=="Y"){
		                        $("#_HospListGrid").datagrid("selectRow", idx);
		                      }
		                });              
		            }
				})
		}
	});
	return gridObj;
}
function GenHospWinButton(objectName){
	objectName = objectName||"";
	if (objectName=="") return null;
	// 如果非管控数据按钮隐藏
	var dataType = tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",objectName);
	var hiddenFlag = dataType=="C"?false:true;
	hiddenFlag = false;
	if (hiddenFlag){
		if ($("#_HospBtn").length>0){
			$("#_HospBtn").hide();
		}
	}else{
		if ($("#_HospBtn").length==0){
			$("<a id=\"_HospBtn\" class=\"textbox\">数据关联医院</a>").prependTo("body");
		}
		var btnobj = $HUI.linkbutton("#_HospBtn",{
			iconCls:'icon-w-key',
			text:'数据关联医院'
		});
	}
	return btnobj;
}
/*个人权限可见医院*/
/*{defaultValue:1}*/
function GenUserHospComp(opt){
	//opt = opt||{defaultValue:session['LOGON.HOSPID']};
	var hospid = (session&&session['LOGON.HOSPID'])||"";
	var defaultOpt = {width:350,defaultValue:hospid};
	opt = $.extend(defaultOpt,opt||{});
	if ($("#_HospUserList").length==0){
		$("<input id=\"_HospUserList\" class=\"textbox\"/>").prependTo("body");
	}
	if ($("#_HospUserListLabel").length==0){
		$("<label id='_HospUserListLabel' style='color:red;margin:0 10px 0 10px' class='r-label'>医院</label>").prependTo("body");
	}
	var obj = $HUI.combogrid('#_HospUserList',{
		delay: 500,
		blurValidValue:true,
		panelWidth:350,
		width:opt.width,
		mode:'remote',
		pagination:true,
		lazy:true,
		editable:false,
		minQueryLen:1,
		value:opt.defaultValue,
		isCombo:true,
		showPageList:false,
		showRefresh:false,
		displayMsg:"当前:{from}~{to},共{total}条",
        onBeforeLoad:function(param){
			param = $.extend(param,{desc:$("#_HospUserList").lookup("getText")});
			return true;
		},
		queryParams:{ClassName:'web.DHCBL.CT.CTHospital',QueryName:'GetDataForCmb1'},
		url: $URL,
		idField: 'HOSPRowId',
		textField: 'HOSPDesc',
		columns: [[
			{field:"HOSPRowId",title:"HOSPRowId",align:"left",hidden:true,width:100},
			{field:"HOSPDesc",title:"医院名称",align:"left",width:300},
			{field:"LinkFlag",title:"LinkFlag",align:"left",hidden:true,width:100},
			{field:"MappingID",title:"MappingID",align:"left",hidden:true,width:100}
		]]
	});
	return obj;
}