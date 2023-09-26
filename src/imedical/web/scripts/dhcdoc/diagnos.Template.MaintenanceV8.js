var PageLogicObj = {
}
var DiagListDataGrid;
var UserDiagTempDataGrid;
var LocDiagTempDataGrid;
var Loctoobar,Datatoolbar;
$(window).load(function(){
	InitTab();
	LoadUserPrivateList();
	InitCombobox();
	
})
$(document).ready(function(){
	/*$('#DiagSearch').keydown(DiagLookUpItem);
	$('#imgDiagSearch').click(DiagLookUpItem);*/
	IntDiagSearch();
	$(document.body).bind("keydown",BodykeydownHandler)
})
function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//回车事件或者
	if (keyCode==13) {
		if (SrcObj && SrcObj.id=="UserTempDesc") {
			AddUserTempClickHandle();
			return false;
		}
		if (SrcObj && SrcObj.id=="LocTempDesc") {
			AddLocTemplHandler();
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("DiagSearch")>=0){
			return false;
		}
		return true;
	}
}
function AddUserTempClickHandle(){
	var desc=$.trim($("#UserTempDesc").val());
	if (desc==""){
		$.messager.alert("提示","新增个人模板名不能为空!","info",function(){
			$("#UserTempDesc").focus();
		})
		return false;
	}
	//var total=parseInt(UserDiagTempDataGrid.datagrid('getData').total);
	$.m({
	    ClassName:"web.DHCDocDiagnosEntryV8",
	    MethodName:"AddPrivate",
	    PrivateDesc:desc,
	    USERID:session['LOGON.USERID'] //,
	   // CTLOCID:session['LOGON.CTLOCID'],
	    //INDEXNum:total+1
	},function(val){
		if (val=="0"){
			$("#UserTempDesc").val("");
			LoadUserPrivateList("1");
			LoadDiagData("");
		}else{
			$.messager.alert("提示","新增失败: "+val,"info",function(){
				$("#UserTempDesc").focus();
			});
			return false;
		}
	});
}
function DelUserTempClickHandle(){
	var sel=UserDiagTempDataGrid.datagrid("getSelected");
	if (sel){
		var id=sel.DHCDIAMASRowid;
		var PrivateDesc=sel.DHCDIADESC;
		$.messager.confirm('确认对话框', '是否删除模板 ' + PrivateDesc + ' 下的所有内容', function(r){
			if (r){
				$.m({
				    ClassName : "web.DHCDocDiagnosNew",
				    MethodName : "PrivateDel",
				    USERID:session['LOGON.USERID'],
				    PrivateorderRowid:id
				},function(val){
				    if ((val=="0")||(val=="100")){
					    //var index= UserDiagTempDataGrid.datagrid('getRowIndex',sel);
					    //UserDiagTempDataGrid.datagrid('deleteRow',index);
					    UserDiagTempDataGrid.datagrid('uncheckAll');
					    LoadUserPrivateList();
					    LoadDiagData("");
					}else{
						$.messager.alert("提示","删除失败!");
						return false;
					}
				}); 
			}
		});
	}else{
		$.messager.alert("提示","请选择需要删除的个人模板!");
		return false;
	}
}
function PrivateChangeName(){
	var sel=UserDiagTempDataGrid.datagrid("getSelected");
	if (sel){
		var NewDescName=$.trim($("#UserTempDesc").val());
		if (NewDescName==""){
			$.messager.alert("提示","修改后的个人模板名称不能为空!","info",function(){
				$("#UserTempDesc").focus();
			});
			return false;
		}
		var id=sel.DHCDIAMASRowid;
		var PrivateDesc=sel.DHCDIADESC;
		$.messager.confirm('确认对话框', '是否修改模板 ' + PrivateDesc + ' 的名称', function(r){
			if (r){
				$.m({
				    ClassName : "web.DHCDocDiagnosNew",
				    MethodName : "PrivateChangeName",
				    USERID:session['LOGON.USERID'],
				    PrivateorderRowid:id,
				    PrivateorderNewName:NewDescName
				},function(val){
				    if (val=="0"){
					    var index= UserDiagTempDataGrid.datagrid('getRowIndex',sel);
					    UserDiagTempDataGrid.datagrid('updateRow',{
							index: index,
							row: {
								DHCDIAMASRowid: id,
								DHCDIADESC: NewDescName
							}
						});
						$("#UserTempDesc").val("");
						$('.editcls-dowm').linkbutton({ plain: true, iconCls: 'icon-arrow-bottom' });
					}else{
						$.messager.alert("提示","修改名称失败: "+val,"info",function(){
							$("#UserTempDesc").focus();
						});
						return false;
					}
				}); 
			}
		});
	}else{
		$.messager.alert("提示","请选择需要修改名称的个人模板!");
		return false;
	}
}
//修改科室模板名称
function LocTemplChangeName(){
	var sel=LocDiagTempDataGrid.datagrid("getSelected");
	if (sel){
		var NewDescName=$.trim($("#LocTempDesc").val());
		if (NewDescName==""){
			$.messager.alert("提示","修改后的科室模板名称不能为空!","info",function(){
				$("#LocTempDesc").focus();
			});
			return false;
		}
		var id=sel.DHCDIAMASRowid;
		var PrivateDesc=sel.DHCDIADESC;
		$.messager.confirm('确认对话框', '是否修改模板 ' + PrivateDesc + ' 的名称', function(r){
			if (r){
				$.m({
				    ClassName : "web.DHCDocDiagnosEntryV8",
				    MethodName : "PrivateChangeName",
				    PrivateorderRowid:id,
				    PrivateorderNewName:NewDescName
				},function(val){
				    if (val=="0"){
					    var index= LocDiagTempDataGrid.datagrid('getRowIndex',sel);
					    LocDiagTempDataGrid.datagrid('updateRow',{
							index: index,
							row: {
								DHCDIAMASRowid: id,
								DHCDIADESC: NewDescName
							}
						});
						$("#LocTempDesc").val("");
						//$("#DiagSearch").focus();
						$('.editcls-up').linkbutton({ plain: true, iconCls: 'icon-arrow-top' });
					}else{
						$.messager.alert("提示","修改名称失败: "+val,"info",function(){
							$("#LocTempDesc").focus();
						});
						return false;
					}
				}); 
			}
		});
	}else{
		$.messager.alert("提示","请选择需要修改名称的科室模板!");
		return false;
	}
}
function ShowLocTemplSaveToOtherLoc(){
	var sel=LocDiagTempDataGrid.datagrid("getSelected");
	if (sel){
		destroyDialog("OtherLocListWin");
	    var Content=initDiagDivHtml()
	    var iconCls="icon-w-edit";
	    createModalDialog("OtherLocListWin","选择科室", 380, 260,iconCls,"确定",Content,"LocTemplSaveToOtherLoc()");
	    $.m({
		    ClassName:"web.DHCDocDiagnosEntryV8",
		    MethodName:"GetUserLogonLocList",
		    UserID:session['LOGON.USERID'],
		    LogLocId:session['LOGON.CTLOCID'],
		    type:"JSON"
		},function(jsonData){
				var cbox = $HUI.combobox("#OtherLocList", {
					width:'200px',
					editable: true,
					multiple:false,
					selectOnNavigation:true,
				  	valueField:'id',
				  	textField:'text',
				  	data:eval("("+jsonData+")"),
				  	filter: function(q, row){
						/*var opts = $(this).combobox('options');
						return row[opts.textField].indexOf(q.toUpperCase()) >= 0;*/
					   if (q=="") return true;
					   var opts = $(this).combobox('options');
					   var code=row["CTLOCCode"];
					   if (row[opts.textField].indexOf(q.toUpperCase()) >= 0){
						   return true;
					   }else{
						  var Find=0;
						  for (var i=0;i<code.split("^").length;i++){
							  var oneCode=code.split("^")[i];
							  if (oneCode.indexOf(q.toUpperCase())>=0) Find=1;
						  } 
						  if (Find=="0") return false;
						  return true;
					   }
				    }
			});
		});
		
	}else{
		$.messager.alert("提示","请选择一条科室模板!");
		return false;
	}
}
function LocTemplSaveToOtherLoc(){
	var sel=LocDiagTempDataGrid.datagrid("getSelected");
	var id=sel.DHCDIAMASRowid;
	var sbox = $HUI.combobox("#OtherLocList");
	var LocId=sbox.getValue();
	var LocDesc=sbox.getText();
	if ((LocId=="")||(LocId==undefined)){
		$.messager.alert("提示","请选择需要保存到的科室!","info",function(){
			$('#LocList').combobox().next('span').find('input').focus();
		});
		return false;
	}
	$.m({
	    ClassName:"web.DHCDocDiagnosEntryV8",
	    MethodName:"AddToCTLocTemplet",
	    MasterRowid:id,
	    CTLocRwoid:LocId
	},function(val){
		if (+val>0){
			destroyDialog("OtherLocListWin");
			$.messager.alert("提示","保存成功!");
		}else{
			$.messager.alert("提示","保存至其它科室失败: "+val);
			return false;
		}
	});
}
function destroyDialog(id){
   if ($("#"+id).length>0){
	   $("body").remove("#"+id); //移除存在的Dialog
   	   $("#"+id).dialog('destroy');
   }
}
function initDiagDivHtml(){
	var html="<div id='DiagWin'>"
	   html +="	<table class='search-table'>"
	       html +="	 <tr>"
	       	html +="	 <td class='r-label'>"
	       		html +="	 请选择科室"
	       	html +="	 </td>"
	       	html +="	 <td>"
	       		html +="	 <input id='OtherLocList' class='text' style='width:250px;'></input>"
	       	html +="	 </td>"
	       html +="	 </tr>"
	   html +="	</table>"
   html += "</div>"
   return html;
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
   if(_btntext==""){
	   var buttons=[{
		   text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
   				destroyDialog(id);
			}
	   }]
   }else{
	   var buttons=[{
			text:_btntext,
			iconCls:_icon,
			handler:function(){
				if(_event!="") eval(_event);
			}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
   				destroyDialog(id);
			}
		}]
   }
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;

    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: false,
        content:_content,
        buttons:buttons
    });
}
function MoveRow(obj,type){
	var sel=obj.datagrid("getSelected");
	var index = obj.datagrid('getRowIndex', sel);
	if ("up" == type) {
        if (index != 0) {
            var toup = obj.datagrid('getData').rows[index];
            var todown = obj.datagrid('getData').rows[index - 1];
            obj.datagrid('getData').rows[index] = todown;
            obj.datagrid('getData').rows[index - 1] = toup;
            obj.datagrid('refreshRow', index);
            obj.datagrid('refreshRow', index - 1);
            obj.datagrid('selectRow', index - 1);
        }
    } else if ("down" == type) {
        var rows = obj.datagrid('getRows').length;
        if (index != rows - 1) {
            var todown = obj.datagrid('getData').rows[index];
            var toup = obj.datagrid('getData').rows[index + 1];
            obj.datagrid('getData').rows[index + 1] = todown;
            obj.datagrid('getData').rows[index] = toup;
            obj.datagrid('refreshRow', index);
            obj.datagrid('refreshRow', index + 1);
            obj.datagrid('selectRow', index + 1);
        }
    }
    $('.editcls-dowm').linkbutton({ plain: true, iconCls: 'icon-arrow-bottom' });
	$('.editcls-up').linkbutton({ plain: true, iconCls: 'icon-arrow-top' });
}
function MoveTemplRow(obj,type){
	var sel=obj.datagrid("getSelected");
	if (sel){
		MoveRow(obj,type)
	    //个人模板顺序保存
	    var PrivateorderStr="";
	    var data = obj.datagrid('getData');
	    for (var i=0;i<data.rows.length;i++){
		    var id=data.rows[i].DHCDIAMASRowid;
		    if (PrivateorderStr=="") PrivateorderStr=id;
		    else PrivateorderStr=PrivateorderStr+"^"+id;
		}
		if (PrivateorderStr==""){
			return false;
		}
	    $.m({
		    ClassName : "web.DHCDocDiagnosEntryV8",
		    MethodName : "PrivateorderSave",
		    PrivateorderStr:PrivateorderStr
		},function(val){
		    
		}); 
	}else{
		$.messager.alert("提示","请选择需要进行移动的记录!");
		return false;
	}
}
function MoveDiagItemRow(obj,type){
	var sel=obj.datagrid("getSelected");
	if (sel){
		MoveRow(obj,type)
		var pageSize=obj.datagrid("options").pageSize;
		var pagNum=obj.datagrid("options").pageNumber; //$(".pagination-num").val()
		var StartNum=pageSize*(pagNum-1)+1;
	    var PrivateorderStr="";
	    var data = obj.datagrid('getData');
	    for (var i=0;i<data.rows.length;i++){
		    var id=data.rows[i].DHCMRDiaICDRowid;
		    if (PrivateorderStr=="") PrivateorderStr=id+","+StartNum;
		    else PrivateorderStr=PrivateorderStr+"^"+id+","+StartNum;
		    StartNum=StartNum+1;
		}
		if (PrivateorderStr==""){
			return false;
		}
	    $.m({
		    ClassName : "web.DHCDocDiagnosEntryV8",
		    MethodName : "DiagItemOrdSave",
		    PrivateorderStr:PrivateorderStr
		},function(val){
			var sel=UserDiagTempDataGrid.datagrid("getSelected");
			if (!sel){
				var sel=LocDiagTempDataGrid.datagrid("getSelected");
			}
			var selValue=sel.DHCDIAMASRowid;
			var CurPageData=DiagListDataGrid.datagrid('getData'); //获取当前页的数据
	        if (CurPageData.rows.length==0){
		        LoadDiagData(selValue,1);
		    }else{
			    LoadDiagData(selValue,"");
			}
		}); 
	}else{
		$.messager.alert("提示","请选择需要进行移动的记录!");
		return false;
	}
}
function InitCombobox(){
	$.q({
	    ClassName : "web.DHCDocDiagnosEntryV8",
	    QueryName : "GetExecuteCTLOC",
	    rows:99999
	},function(GridData){
	   var cbox = $HUI.combobox("#LocList", {
		   valueField: 'CTLOCRowid',
		   textField: 'CTLOCDesc',
		   data: GridData.rows,
		   onSelect:function(record){
			   var locId=record.CTLOCRowid;
			   //if (ServerObj.IsHaveMenuAuthDiagFav!="1"){
			   		ChangeItemStatus(locId);
			   //}
			   LoadLocTempDataList(locId);
			   UserDiagTempDataGrid.datagrid('clearSelections');
				$("#DiagSearch").focus();
				LoadDiagData("");
		   },
		   onLoadSuccess:function(){
			   var sbox = $HUI.combobox("#LocList");
			   sbox.select(session['LOGON.CTLOCID']);
		   },
		   filter:function(q, row){
			   if (q=="") return true;
			   var opts = $(this).combobox('options');
			   var code=row["CTLOCCode"];
			   if (row[opts.textField].indexOf(q.toUpperCase()) >= 0){
				   return true;
			   }else{
				  var Find=0;
				  for (var i=0;i<code.split("^").length;i++){
					  var oneCode=code.split("^")[i];
					  if (oneCode.indexOf(q.toUpperCase())>=0) Find=1;
				  } 
				  if (Find=="0") return false;
				  return true;
			   }
		   }
	   })
	}); 
	var cbox = $HUI.combobox("#catType", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: [
		  {"id":"0","text":$g("西医"),"selected":true}
		 ,{"id":"1","text":$g("中医")}
		 ,{"id":"2","text":$g("证型")}
		],
		onSelect: function (rec) {
			$("#DiagSearch").lookup("setText",'').focus();
		}
   });
}
function ChangeItemStatus(locId){
	if (ServerObj.IsHaveMenuAuthDiagFav!="1"){
		LocDiagTempDataGrid.datagrid({toolbar:[]});
		DiagListDataGrid.datagrid({toolbar:[]});
   		$("#catType").combobox('disable');
   		$("#DiagSearch").lookup('disable');
   		$("#LocTempDesc").val('').prop("disabled",true); 
	}else{
		//判断该用户是否有权限维护科室模板
	   if ((ServerObj.UserLogonLocStr.indexOf("^"+locId+"^")==-1)||(ServerObj.UserLogonLocStr=="")){
		   LocDiagTempDataGrid.datagrid({toolbar:[]});
		   //$('div.datagrid-toolbar').eq(1).hide();
		   DiagListDataGrid.datagrid({toolbar:[]});
		   $("#catType").combobox('disable');
		   $("#DiagSearch").lookup('disable');
		   $("#LocTempDesc").val('').prop("disabled",true);  
	   }else{
		   //$('div.datagrid-toolbar').eq(1).show();
		   LocDiagTempDataGrid.datagrid({toolbar:Loctoobar});
		   DiagListDataGrid.datagrid({toolbar:Datatoolbar});
		   $("#catType").combobox('enable');
		   $("#DiagSearch").lookup('enable');
		   $("#LocTempDesc").val('').prop("disabled",false);
	   }
   }
}
function InitTab(){
	//个人模板列表
	var Usertoobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddUserTempClickHandle(); }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelUserTempClickHandle();}
    },{
        text: '修改名称',
        iconCls: 'icon-edit',
        handler: function() { PrivateChangeName();}
    },'-', {
        iconCls: 'icon-arrow-top',
        handler: function() { 
        	var obj = new Object();
        	obj=UserDiagTempDataGrid;
        	MoveTemplRow(obj,"up");
        }
    },{
        iconCls: 'icon-arrow-bottom',
        handler: function() { 
        	var obj = new Object();
        	obj=UserDiagTempDataGrid;
        	MoveTemplRow(obj,"down");
        }
    }];
	var UserColumns=[[ 
		{field:'DHCDIAMASRowid',hidden:true,title:''},
		{field:'DHCDIADESC',title:'模板名称',width:300},
		{field:'btn',title:'保存至科室',width:100,align:'center',
			formatter:function(value,rec){
				if (ServerObj.IsHaveMenuAuthDiagFav=="1"){  
	               var btn = '<a class="editcls-dowm" onclick="SaveToLoc(\'' + rec.DHCDIAMASRowid + '\')"></a>';
			       return btn;
		        }else{
			        return '';
			    }
            }
		}
    ]]
	UserDiagTempDataGrid=$("#UserDiagTempTable").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  //
		rownumbers : true,  //
		pageSize: 10,
		pageList : [10,100,200],
		idField:'DHCDIAMASRowid',
		columns :UserColumns,
		toolbar:Usertoobar,
		onSelect:function(index, row){
			LocDiagTempDataGrid.datagrid('clearSelections');
			$("#DiagSearch").focus();
			LoadDiagData(row.DHCDIAMASRowid);
			DiagListDataGrid.datagrid({toolbar:Datatoolbar});
			//$("#DiagAddDiv").show();
			$("#catType").combobox('enable');
		   $("#DiagSearch").lookup('enable');
		   $("#LocTempDesc").val('')//.prop("disabled",false);
		},onLoadSuccess: function () {
            $('.editcls-dowm').linkbutton({ plain: true, iconCls: 'icon-arrow-bottom' });
        }
	}); 
	//科室模板列表
	Loctoobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddLocTemplHandler(); }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelLocTemplHandler();}
    },{
        text: '修改名称',
        iconCls: 'icon-edit',
        handler: function() { LocTemplChangeName();}
    },'-', {
        text: '保存到其它科室',
        iconCls: 'icon-save',
        handler: function() { ShowLocTemplSaveToOtherLoc();}
    },'-', {
        iconCls: 'icon-arrow-top',
        handler: function() { 
        	var obj = new Object();
        	obj=LocDiagTempDataGrid;
        	MoveTemplRow(obj,"up");
        }
    },{
        iconCls: 'icon-arrow-bottom',
        handler: function() { 
        	var obj = new Object();
        	obj=LocDiagTempDataGrid;
        	MoveTemplRow(obj,"down");
        }
    }];
	var LocColumns=[[ 
		{field:'DHCDIAMASRowid',hidden:true,title:''},
		{field:'DHCDIADESC',title:'模板名称',width:300},
		{field:'btn',title:'保存至个人',width:100,align:'center',
			formatter:function(value,rec){  
               var btn = '<a class="editcls-up" onclick="SaveToUser(\'' + rec.DHCDIAMASRowid + '\')"></a>';
		       return btn;
            }
		},
		{field:'CTlocRowid',hidden:true,title:''}
    ]];
	LocDiagTempDataGrid=$("#LocDiagTempTable").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  //
		rownumbers : true,  //
		pageSize: 10,
		pageList : [10,100,200],
		idField:'DHCDIAMASRowid',
		columns :LocColumns,
		toolbar:Loctoobar,
		onSelect:function(index, row){
			UserDiagTempDataGrid.datagrid('clearSelections');
			$("#DiagSearch").focus();
			LoadDiagData(row.DHCDIAMASRowid);
			ChangeItemStatus(row.CTlocRowid);
			LocDiagTempDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',$(this).datagrid('getData'));
		},
        onLoadSuccess: function () {
            $('.editcls-up').linkbutton({ plain: true, iconCls: 'icon-arrow-top' });
        }
	})
	
	//模板内容列表
	Datatoolbar=[{
        text: '增加非ICD诊断',
        iconCls: 'icon-add',
        handler: function() {DiagnosDeschandler(); }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelDiagDataHandler();}
    },'-', {
        iconCls: 'icon-arrow-top',
        handler: function() { 
        	var obj = new Object();
        	obj=DiagListDataGrid;
        	MoveDiagItemRow(obj,"up");
        }
    },{
        iconCls: 'icon-arrow-bottom',
        handler: function() { 
            var obj = new Object();
        	obj=DiagListDataGrid;
        	MoveDiagItemRow(obj,"down");
        }
    },'-',{
	    text: '保存诊断备注',
	    iconCls: 'icon-save',
        handler: function() { 
            SaveICDDiagNotes();
        }
	}];
	var DataColumns=[[ 
	    {field:'DHCMRDiaICDRowid',hidden:true,title:''},
		{field:'DHCMRDiaICDICDDR',hidden:true,title:''},
		{field:'DHCMRDiaICDICDDesc',title:'诊断名称',width:400},
		{field:'DHCMRDiaICDICDNotes',title:'ICD诊断备注',width:200,
			editor:{type : 'text'}
		}
    ]];
	DiagListDataGrid=$("#DiagListTable").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  //
		rownumbers : true,  //
		pageSize: 10,
		pageList : [10,100,200],
		idField:'DHCMRDiaICDICDDR',
		columns :DataColumns,
		toolbar:Datatoolbar,
		onLoadSuccess:function(data){
			if (data['rows'].length>=0){
				for (var i=0;i<data['rows'].length;i++){
					if (data['rows'][i]["DHCMRDiaICDICDDR"].split("*")[0]!="") {
						$("#DiagListTable").datagrid('beginEdit',i);
					}
					GridBindEnterEvent(i);
				}
			}
		}
	})
}
//增加科室模板
function AddLocTemplHandler(){
	var LocTempDesc=$.trim($("#LocTempDesc").val());
	if (LocTempDesc==""){
		$.messager.alert("提示","新添加的科室模板名不能为空!","info",function(){
			$('#LocTempDesc').focus();
		});
		return false;
	}
	var sbox = $HUI.combobox("#LocList");
	var LocId=sbox.getValue();
	var LocDesc=sbox.getText();
	if ((LocId=="")||(LocId==undefined)){
		$.messager.alert("提示","请选择需要添加模板的科室!","info",function(){
			$('#LocList').combobox().next('span').find('input').focus();
		});
		return false;
	}
	$.m({
	    ClassName:"web.DHCDocDiagnosEntryV8",
	    MethodName:"AddLocTemplet",
	    CTLocRowid:LocId,
	    Name:LocTempDesc
	},function(val){
		if (val=="0"){
			$("#LocTempDesc").val("");
			LoadLocTempDataList(LocId,1);
			LoadDiagData("");
		}else{
			$.messager.alert("提示","科室模板添加失败: "+val,"info",function(){
				$("#LocTempDesc").focus();
			});
			return false;
		}
	});
}
//删除科室模板
function DelLocTemplHandler(){
	var sel=LocDiagTempDataGrid.datagrid("getSelected");
	if (sel){
		var id=sel.DHCDIAMASRowid;
		var PrivateDesc=sel.DHCDIADESC;
		$.messager.confirm('确认对话框', '是否删除科室模板【 ' + PrivateDesc + ' 】下的所有内容', function(r){
			if (r){
				$.m({
				    ClassName : "web.DHCDocDiagnosEntryV8",
				    MethodName : "LocTemplateDel",
				    PrivateorderRowid:id
				},function(val){
				    if ((val=="0")||(val=="100")){
					    var sbox = $HUI.combobox("#LocList");
						var LocId=sbox.getValue();
						LocDiagTempDataGrid.datagrid('uncheckAll');
					    LoadLocTempDataList(LocId);
					    LoadDiagData("");
					}else{
						$.messager.alert("提示","删除失败!");
						return false;
					}
				}); 
			}
		});
	}else{
		$.messager.alert("提示","请选择需要删除的科室模板!");
		return false;
	}
}
function LoadUserPrivateList(type){
	if (typeof(type) == "undefined") type="";
	$.q({
	    ClassName : "web.DHCDocDiagnosEntryV8",
	    QueryName : "DiagTemplateList",
	    USERID : session['LOGON.USERID'],
	    Pagerows:UserDiagTempDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		UserDiagTempDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		if (type=="1"){
			var total=parseInt(UserDiagTempDataGrid.datagrid('getData').total);
			var pageSize=parseInt(UserDiagTempDataGrid.datagrid("options").pageSize);
			var LastPage=Math.ceil(total/pageSize);
			if (LastPage>1){
				UserDiagTempDataGrid.datagrid('getPager').pagination('select',LastPage); //跳转到最后一页
				var LastPageData=UserDiagTempDataGrid.datagrid('getData');
				UserDiagTempDataGrid.datagrid("scrollTo",LastPageData.rows.length-1)
			    UserDiagTempDataGrid.datagrid("selectRow",LastPageData.rows.length-1);
			    LocDiagTempDataGrid.datagrid("clearSelections");
			}else{
				UserDiagTempDataGrid.datagrid("selectRow",total-1);
			}
			LocDiagTempDataGrid.datagrid("clearSelections");
			$("#DiagSearch").focus();
			
		}
	}); 
}
function pagerFilter(data){
	if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		showRefresh:false,
		onSelectPage:function(pageNum, pageSize){
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
				pageNumber:pageNum,
				pageSize:pageSize
			});
			dg.datagrid('loadData',data);
			dg.datagrid('scrollTo',0); //滚动到指定的行        
			/*
			刷新当前页的选中行,源码里面做了延迟，要保证堆栈执行顺序，
			这里也要加
			*/
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	if ((start+1)>data.originalRows.length){
		//取现有行数最近的整页起始值
		start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
		opts.pageNumber=opts.pageNumber-1;
	}
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}
function SaveToLoc(id){
	var sbox = $HUI.combobox("#LocList");
	var LocId=sbox.getValue();
	var LocDesc=sbox.getText();
	if ((LocId=="")||(LocId==undefined)){
		$.messager.alert("提示","请选择需要保存到的科室!","info",function(){
			$('#LocList').combobox().next('span').find('input').focus();
		});
		return false;
	}else{
		if (((ServerObj.UserLogonLocStr!="")&&(ServerObj.UserLogonLocStr.indexOf("^"+LocId+"^")==-1))||(ServerObj.UserLogonLocStr=="")){
			$.messager.alert("提示","没有权限把个人模板保存到 "+LocDesc+",请核实!");
			return false;
		}
	}
	$.m({
	    ClassName:"web.DHCDocDiagnosEntryV8",
	    MethodName:"AddToCTLocTemplet",
	    MasterRowid:id,
	    CTLocRwoid:LocId
	},function(val){
		if (+val>0){
			LoadUserPrivateList();
			LoadLocTempDataList(LocId,1);
		}else{
			$.messager.alert("提示","保存至科室模板失败: "+val);
			return false;
		}
	});
}
function SaveToUser(id){
	//保存到个人模板
	$.m({ 
	    ClassName:"web.DHCDocDiagnosNew",
	    MethodName:"CTLocAddToPrivate",
	    CTLocTempletRowid:id,
	    USERID:session['LOGON.USERID']
	},function(val){
		if (+val>0){
			LoadUserPrivateList(1);
			LoadLocTempDataList(LocId);
		}else{
			$.messager.alert("提示","保存至个人模板失败: "+val);
			return false;
		}
	});
}
var ItemzLookupGrid;
/*function DiagLookUpItem(e){
	try{
		var obj=websys_getSrcElement(e);
		var type=websys_getType(e);
		var key=websys_getKey(e);
		var catType = $HUI.combobox("#catType").getValue();
		var Desc=$("#DiagSearch").val(); 
		if ((key == 13) || (type == 'dblclick')||(obj.id == 'imgDiagSearch')||((Desc.length>0)&&(key>64 && key<91))) {
	        if (ItemzLookupGrid && ItemzLookupGrid.store) {
		        ItemzLookupGrid.searchAndShow([function() { return $("#DiagSearch").val(); }, "", "", "", function(){return $HUI.combobox("#catType").getValue()}]);
		    } else {
		        ItemzLookupGrid = new dhcc.icare.Lookup({
		            lookupListComponetId: 1872,
		            lookupPage: "诊断选择",
		            lookupName: "DiagSearch",
		            listClassName: 'web.DHCMRDiagnos',
		            listQueryName: 'LookUpWithAlias',
		            resizeColumn: false,
		            queryDelay : 200,
		            listProperties: [function() { return $("#DiagSearch").val(); }, "", "", "", function(){return $HUI.combobox("#catType").getValue()}],
		            listeners: { 
		                'selectRow': DiagnosSelhandler
		            },
		            isCombo: true
		        });
		    }
		}
	}catch(e){}
}*/
function IntDiagSearch(){
	$("#DiagSearch").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'desc',
        columns:[[  
            {field:'desc',title:'诊断名称',width:300,sortable:true},
			{field:'code',title:'code',width:120,sortable:true},
			{field:'HIDDEN',title:'HIDDEN',width:120,sortable:true,hidden:true}
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:410,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCMRDiagnos',QueryName: 'LookUpWithAlias'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        var DiaType=$HUI.combobox("#catType").getValue();
			param = $.extend(param,{desc:desc,ICDType:DiaType});
	    },onSelect:function(ind,item){
            var Desc=item['desc'];
			var ID=item['HIDDEN'];
			DiagnosSelhandler(Desc+"^"+ID);
			$HUI.lookup("#AdmDiadesc").clear();
			$HUI.lookup("#AdmDiadesc").hidePanel();
		}
    });
}
function DiagnosSelhandler(value){
	var sel=UserDiagTempDataGrid.datagrid("getSelected");
	if (!sel){
		var sel=LocDiagTempDataGrid.datagrid("getSelected");
	}
	if (!sel){
		$.messager.alert("提示","请选择一条个人模板或科室模板!","info",function(){
			$("#DiagSearch").lookup("setText",'').focus();
		});
		return false;
	}
	var selValue=sel.DHCDIAMASRowid;
	var listArry=value.split("^")
	var DiagnosDesc=listArry[0];
	var DiagnosValue=listArry[1];
	var catType = $HUI.combobox("#catType").getValue();
	if (catType=="2"){ //添加证型
		var ret=AddSyndromItem(DiagnosValue,DiagnosDesc);
		if (ret) SaveDiagItemData();
	}else{
		var ret=AddRowDiagItem(DiagnosValue,DiagnosDesc);
		if (ret) {
			SaveDiagItemData(1);
		}
	}
}
function AddRowDiagItem(DiagnosValue,DiagnosDesc){
	var CurPageData=DiagListDataGrid.datagrid('getData'); //获取当前页的数据
	DiagListDataGrid.datagrid('appendRow',{
			DHCMRDiaICDICDDR: DiagnosValue,
			DHCMRDiaICDICDDesc: DiagnosDesc,
			DHCMRDiaICDICDNotes:"",
			DHCMRDiaICDRowid:""
	});
	DiagListDataGrid.datagrid("selectRow",CurPageData.rows.length-1);
	$("#DiagSearch").lookup("setText",'').focus();
	return true;
}
function AddSyndromItem(DiagnosValue,DiagnosDesc){
	var newValue="",newText="";
	var sel=DiagListDataGrid.datagrid("getSelected");
	if (sel){
		var id=sel.DHCMRDiaICDICDDR;
		var text=sel.DHCMRDiaICDICDDesc;
		var DHCMRDiaICDRowid=sel.DHCMRDiaICDRowid;
		var index=DiagListDataGrid.datagrid("getRowIndex",sel); //DiagListDataGrid.datagrid("getRowIndex",id);
		var editors = $("#DiagListTable").datagrid('getEditors', index);
		if (editors.length>0){
			var DHCMRDiaICDICDNotes=editors[0].target.val();
		}else{
			var DHCMRDiaICDICDNotes="";
		}
		var selMaterIdInfo=id.split("*")[0];
		var selMaterTextInfo=text.split("*")[0];
		if (selMaterIdInfo.indexOf("$")==-1){
			var masterId=selMaterIdInfo;
			if(masterId!=""){
				//判断是否是中医诊断 
				var ret=tkMakeServerCall("web.DHCMRDiagnos","CheckIsCNICD",masterId);
				if (ret=="0") {
					$.messager.alert("提示","请选中一条中医诊断!","info",function(){
						$("#DiagSearch").focus();
					});
					return false;
				}
			}
		}
		var OldTextSyndromInfo=text.split("*")[1];
		if ((OldTextSyndromInfo=="")||(OldTextSyndromInfo==undefined)){
			newText=selMaterTextInfo+"*"+DiagnosDesc;
		}else{
			newText=selMaterTextInfo+"*"+OldTextSyndromInfo+"!"+DiagnosDesc;
		}
		var SyndromInfo=id.split("*")[1];
	    if ((SyndromInfo=="")||(SyndromInfo==undefined)){
		    if (DiagnosValue!=""){
			    newValue=selMaterIdInfo+"*"+DiagnosValue+"#";
			}else{
				newValue=selMaterIdInfo+"*"+DiagnosValue+"#"+DiagnosDesc;
			}
		}else{
			var IdSyndromInfo=SyndromInfo.split("#")[0];
			var TextSyndromInfo=SyndromInfo.split("#")[1];
			if ((IdSyndromInfo=="")&&(TextSyndromInfo=="")){
				if (DiagnosValue!=""){
				    newValue=selMaterIdInfo+"*"+DiagnosValue+"#";
				}else{
					newValue=selMaterIdInfo+"*"+DiagnosValue+"#"+DiagnosDesc;
				}
			}else{
				if (DiagnosValue!=""){
					if (("!"+IdSyndromInfo+"!").indexOf("!"+DiagnosValue+"!")>=0){
						$.messager.alert("提示",DiagnosDesc+" 已存在!","info",function(){
							$("#DiagSearch").focus();
						});
						return false;
					}
					newValue=selMaterIdInfo+"*"+IdSyndromInfo+"!"+DiagnosValue+"#"+TextSyndromInfo+"!";
				}else{
					if (("!"+TextSyndromInfo+"!").indexOf("!"+DiagnosDesc+"!")>=0){
						$.messager.alert("提示",DiagnosDesc+" 已存在!","info",function(){
							$("#DiagSearch").focus();
						});
						return false;
					}
					newValue=selMaterIdInfo+"*"+IdSyndromInfo+"!"+DiagnosValue+"#"+TextSyndromInfo+"!"+DiagnosDesc;
				}
				
			}
		}
		if (newValue!="") DiagnosValue=newValue;
        if (newText!="") DiagnosDesc=newText;
        DiagListDataGrid.datagrid('updateRow',{
			index: index,
			row: {
				DHCMRDiaICDICDDR: newValue,
				DHCMRDiaICDICDDesc: newText,
				DHCMRDiaICDICDNotes: DHCMRDiaICDICDNotes,
				DHCMRDiaICDRowid:DHCMRDiaICDRowid
			}
		});
        $("#DiagSearch").lookup("setText",'').focus();
        return true;
	}else{
		$.messager.alert("提示","请选中一条中医诊断!","info",function(){
			$("#DiagSearch").focus();
		})
		return false;
	}
	return true;
}
function SaveDiagItemData(isReLoadFlag){
	if (typeof isReLoadFlag =="undefined"){isReLoadFlag="";}
	var sel=DiagListDataGrid.datagrid("getSelected");
	if (sel){
		var DiagnosValue=sel.DHCMRDiaICDICDDR;
		var DiagnosText=sel.DHCMRDiaICDICDDesc;
		var DHCMRDiaICDRowid=sel.DHCMRDiaICDRowid; //模板明细ID
		var MainICDInfo="",NewSyndromInfo="",mainId="";
		if (DiagnosValue!=""){
			  var mainId=DiagnosValue.split("*")[0];
		      var mainText=DiagnosText.split("*")[0];
		      if ((mainId=="")&&(mainText!="")){
			      MainICDInfo="$"+mainText;
			  }else{
				  MainICDInfo=mainId;
			  }
			  var SyndromInfo=DiagnosValue.split("*")[1];
			  if ((SyndromInfo!="")&&(SyndromInfo!=undefined)){
				 var idStr=SyndromInfo.split("#")[0];
				 var descStr=SyndromInfo.split("#")[1];
				 for (var m=0;m<idStr.split("!").length;m++){
					 var oneId=idStr.split("!")[m];
					 if (oneId==""){
						 oneId=descStr.split("!")[m];
					 }
					 if (oneId=="") continue;
					 if (NewSyndromInfo=="") NewSyndromInfo=oneId;
					 else NewSyndromInfo=NewSyndromInfo+"!"+oneId;
				 }
			  }
			  if (NewSyndromInfo!="") MainICDInfo=MainICDInfo+"!"+NewSyndromInfo;
			  if (MainICDInfo!="") DiagnosValue=MainICDInfo;
		}else{
		   if ((DiagnosValue=="")&&(DiagnosText!="")){
		      DiagnosValue=DiagnosValue+"$"+DiagnosText
		   }
		}
		var sel1=UserDiagTempDataGrid.datagrid("getSelected");
		if (!sel1){
			var sel1=LocDiagTempDataGrid.datagrid("getSelected");
		}
		var selValue=sel1.DHCDIAMASRowid;
		$.m({
		    ClassName:"web.DHCDocDiagnosNew",
		    MethodName:"PrivateSaveNew",
		    USERID:session['LOGON.USERID'],
		    selValue:selValue,
		    DiagnosStr:DiagnosValue,
		    ListNum:"1",
		    DHCMRDiaICDRowid:DHCMRDiaICDRowid,
			catType:$("#catType").combobox('getValue')
		},function(val){
			var Ret=val.split("^")[0];
    		var Message=val.split("^")[1];
    		var rowid=val.split("^")[2];
			if (Ret=="0"){
				var index=DiagListDataGrid.datagrid("getRowIndex",sel);
				if (Message!=""){
					$.messager.alert("提示",Message+" 已存在!","info",function(){
						DiagListDataGrid.datagrid('deleteRow',index);
					});
					return false;
				}
				if (rowid!=""){
					DiagListDataGrid.datagrid('updateRow',{
						index: index,
						row: {
							DHCMRDiaICDRowid:rowid
						}
					});
				}
			}
			$("#DiagSearch").lookup("setText",'').focus();
			if (isReLoadFlag=="1"){
				LoadDiagData(selValue,1);
				/*var CurPageData=DiagListDataGrid.datagrid('getData'); //获取当前页的数据
		        var pageSize=parseInt(DiagListDataGrid.datagrid("options").pageSize);
		        if (CurPageData.rows.length>pageSize){
			        LoadDiagData(selValue,1);
			    }*/
			}else{
				if (mainId!="") {
					$("#DiagListTable").datagrid('beginEdit',index);
					GridBindEnterEvent(index);
				}
			}
		});
		
	}else{
		$.messager.alert("提示","请选中一个个人模板或科室模板!")
		return false;
	}
}
function DiagnosDeschandler(){
	var sel=UserDiagTempDataGrid.datagrid("getSelected");
	if (!sel){
		var sel=LocDiagTempDataGrid.datagrid("getSelected");
	}
	if (!sel){
		$.messager.alert("提示","请选择一条个人模板或科室模板!","info",function(){
			$("#DiagSearch").lookup("setText",'').focus();
		});
		return false;
	}
	var selValue=sel.DHCDIAMASRowid;
	var DiagnosDesc=$("#DiagSearch").lookup("getText");
	var DiagnosValue="";
	if((DiagnosDesc=="")&&(DiagnosValue=="")){
		$.messager.alert("提示","请在诊断名称处录入非ICD诊断!","info",function(){
			$("#DiagSearch").focus();
		})
		return false;
	}
	var catType = $HUI.combobox("#catType").getValue();
	if (catType=="2"){ //添加证型
		var ret=AddSyndromItem(DiagnosValue,DiagnosDesc);
		if (ret) SaveDiagItemData();
	}else{
		var ret=AddRowDiagItem(DiagnosValue,DiagnosDesc);
		if (ret) {
			SaveDiagItemData(1);
		}
	}
}
function DelDiagDataHandler(){
	var sel=DiagListDataGrid.datagrid("getSelected");
	var index=DiagListDataGrid.datagrid("getRowIndex",sel);
	if (sel){
		var id=sel.DHCMRDiaICDRowid;
		$.m({
		    ClassName:"web.DHCDocDiagnosEntryV8",
		    MethodName:"delOneDiagItem",
		    id:id,
		},function(val){
			DiagListDataGrid.datagrid('deleteRow',index);
			var sel=UserDiagTempDataGrid.datagrid("getSelected");
			if (!sel){
				var sel=LocDiagTempDataGrid.datagrid("getSelected");
			}
			var selValue=sel.DHCDIAMASRowid;
			var CurPageData=DiagListDataGrid.datagrid('getData'); //获取当前页的数据
	        if (CurPageData.rows.length==0){
		        LoadDiagData(selValue,1);
		    }else{
			    LoadDiagData(selValue,"");
			}
		});
	}else{
		$.messager.alert("提示","请选择需要删除的诊断记录!");
		return false;
	}
}
function LoadDiagData(id,type){
	if (typeof(type) == "undefined") type="";
	$.q({
	    ClassName : "web.DHCDocDiagnosNew",
	    QueryName : "DiagTemplateDetailList",
	    MASTERDR : id,
	    Pagerows:DiagListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		DiagListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		if (type=="1"){
			var total=parseInt(DiagListDataGrid.datagrid('getData').total);
			var pageSize=parseInt(DiagListDataGrid.datagrid("options").pageSize);
			var LastPage=Math.ceil(total/pageSize);
			if (LastPage>1){
				DiagListDataGrid.datagrid('getPager').pagination('select',LastPage); //跳转到最后一页
				var LastPageData=DiagListDataGrid.datagrid('getData');
				DiagListDataGrid.datagrid("scrollTo",LastPageData.rows.length-1);
			    DiagListDataGrid.datagrid("selectRow",LastPageData.rows.length-1);
			    $("#DiagSearch").focus();
			}else{
				DiagListDataGrid.datagrid("selectRow",total-1);
			}
		}
	});
}
function LoadLocTempDataList(locId,type){
	if (typeof(type) == "undefined") type="";
	$.q({
	    ClassName : "web.DHCDocDiagnosEntryV8",
	    QueryName : "GetCTLocTemplet",
	    CTlocRowid : locId,
	    Pagerows:LocDiagTempDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		LocDiagTempDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		if (type=="1"){
			var total=parseInt(LocDiagTempDataGrid.datagrid('getData').total);
			var pageSize=parseInt(LocDiagTempDataGrid.datagrid("options").pageSize);
			var LastPage=Math.ceil(total/pageSize);
			if (LastPage>1){
				LocDiagTempDataGrid.datagrid('getPager').pagination('select',LastPage); //跳转到最后一页
				var LastPageData=LocDiagTempDataGrid.datagrid('getData');
				LocDiagTempDataGrid.datagrid("scrollTo",LastPageData.rows.length-1)
			    LocDiagTempDataGrid.datagrid("selectRow",LastPageData.rows.length-1);
			    $("#DiagSearch").focus();
			}else{
				LocDiagTempDataGrid.datagrid("selectRow",total-1);
			}
			UserDiagTempDataGrid.datagrid("clearSelections");
		}
	});
}
function GridBindEnterEvent(index){
	var eds = $("#DiagListTable").datagrid('getEditors',index);
	if (eds.length>0) {
		eds[0].target.bind('keydown', function(e){
			if (e.keyCode == 13) {
				var input = $(e.target).val();
				if (input == ""){return;}
				var rows=$("#DiagListTable").datagrid('getRows');
				if (index==(rows.length-1)) {
					index=-1;
				}
				for (var i=parseInt(index)+1;i<rows.length;i++){
					var Nexteditors = $("#DiagListTable").datagrid('getEditors', i);
					if (Nexteditors.length>0){
						var NextOrderPriceEditor= Nexteditors[0];
						NextOrderPriceEditor.target.focus().select();  ///设置焦点并选中
						break;
					}
				}
			}
		});
	}
}
function SaveICDDiagNotes(){
	var rows=$("#DiagListTable").datagrid('getRows');
	if (rows.length==0) {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var IDs=[];
	for (var i=0;i<rows.length;i++) {
		var editors = $("#DiagListTable").datagrid('getEditors', i);
		if (editors.length>0){
			var DHCMRDiaICDICDNotes=editors[0].target.val();
			if (DHCMRDiaICDICDNotes!="") DHCMRDiaICDICDNotes=DHCMRDiaICDICDNotes.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g,"")
			IDs[IDs.length]={
				DHCMRDiaICDRowid:rows[i].DHCMRDiaICDRowid,
				DHCMRDiaICDICDNotes:DHCMRDiaICDICDNotes
			}
		}
    }
    if (IDs.length==0) {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var IDsJson=JSON.stringify(IDs);
	var rtn = cspRunServerMethod(ServerObj.SaveTemplICDDiagNotesMethod, IDsJson);
	if (rtn==0) {
		$.messager.popover({msg: '保存成功！',type:'success'});
	}else{
		$.messager.alert("提示","保存ICD诊断备注失败!");
		return false;
	}
}
