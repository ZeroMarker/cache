var PageLogicObj={
	m_ScheduleTemplateListDataGrid:"",
	m_TabAppQtyListDataGrid:"",
	m_LogLocID:session['LOGON.CTLOCID'],
	m_ClassName:'DHCDoc.DHCDocCure.RBCResPlan',
	m_QueryName:'FindScheduleTemp',
	m_SelectTimeRange:"",
	m_SelectSG:"",
	m_LoadSessTimer:"",
	m_AddFlag:1,
	m_ASLoad:""
}
$(document).ready(function(){
	if(ServerObj.ToLocFlag=="Y"){
		LoadSuccessInit();
	}else{
		InitHospUser();
	}
 	InitEvent();
});	

function InitHospUser(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_SchePlan",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		if (!CheckDocCureUseBase()){
			return;
		}
		$("#Loc_Search,#Doc_Search").combobox('setValue',"");
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		LoadSuccessInit();
	}
}

function LoadSuccessInit(){
	if (!CheckDocCureUseBase()){
		return;
	}
	Init();
	InitCache();
}
function CheckDocCureUseBase(){
	var UserHospID=Util_GetSelHospID();
	var DocCureUseBase=$.m({
		ClassName:"DHCDoc.DHCDocCure.VersionControl",
		MethodName:"UseBaseControl",
		HospitalId:UserHospID,
		dataType:"text"
	},false);
	if (DocCureUseBase=="1"){
		$(".window-mask.alldom").show();
		return false;
	}else{
		$(".window-mask.alldom").hide();
		return true;
	}
}

function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitEvent(){
	$("#BAddDoc").click(function(){
		PageLogicObj.m_AddFlag=1;
		ResClick("","","","","","");
	});

	$("#BatchSchedule").click(GenSche);
	$("#BtnAdd").click(function(){
		SaveClick("Add");
	});
	$("#BtnSave").click(function(){
		SaveClick("Update");
	});
	$("#BtnDelete").click(function(){
		DeleteSess();
	});
	$("#mm-weekclose").click(DeleteSessByWeek);
	$("#mm-servicegroupclose").click(DeleteSessByServiceGroup);
	
	$('#btnImport').click(ImportTemplate);
	
	$HUI.radio("input[name='ClickType']",{
        onCheckChange:function(e,value){
           if (e.currentTarget.value==3){
	           $('.datagrid-body [class*="datagrid-'+ServerObj.datagridCellName+'-Week"]').parent().draggable('enable');
	       }else{
		       $('.datagrid-body [class*="datagrid-'+ServerObj.datagridCellName+'-Week"]').parent().draggable('disable');
		   }
		   $(".droppable").unbind("mousedown");
		   //$(document).unbind("mousedown");
        }
    });
    
	$("#btnFind").click(function(){
		LoadCureRBCResPlanDataGrid()
	});
	$("#TimeRangeFlag").checkbox({
		onCheckChange:function(e,val){
			ChangeTREleStyle(val);
		}
	})
	$("#TRLength").numberbox({
		onChange:function(newValue,oldValue){
			TRInfoCalculateHandle("N");
		}
	});
	
	$('#btnDownLoad').click(DownLoadClickHandle);
	document.onkeydown = Doc_OnKeyDown;
}

function PageHandle(){

}
function Init(){
	if (PageLogicObj.m_ScheduleTemplateListDataGrid==""){
		PageLogicObj.m_ScheduleTemplateListDataGrid=InitScheduleTemplateListDataGrid();
	}else{
		LoadCureRBCResPlanDataGrid();
	}
	PageLogicObj.m_TabAppQtyListDataGrid=InitTabAppQtyList();
	InitSingleCombo('Loc_Search','LocId','LocDesc','QueryCureLoc',"",'DHCDoc.DHCDocCure.Config');
	InitSingleCombo('Doc_Search','TRowid','TResDesc','QueryResource',"",'DHCDoc.DHCDocCure.Config');
	InitSingleCombo('LocList','LocId','LocDesc','QueryCureLoc',"",'DHCDoc.DHCDocCure.Config');
	InitSingleCombo('ResourceList','TRowid','TResDesc','QueryResource',"",'DHCDoc.DHCDocCure.Config');
	InitSingleCombo('DayOfWeek','WeekId','WeekName','QueryWeek');
	InitSingleCombo('ServiceGroup','Rowid','Desc','QueryServiceGroup',"",'DHCDoc.DHCDocCure.RBCServiceGroupSet');
	InitSingleCombo('TimeDesc','Rowid','Desc','QueryBookTime');
	InitDOWTabs();
	InitSGTabs();
	InitTRTabs();
}
function InitScheduleTemplateListDataGrid(){
	var weekObj={field:'',title:'',align:'center',width:90,resizable:true,
		styler: function(value,row,index){
			var style='cursor:pointer;';
			if(value) {
				var flag=value.split('^')[1];
				if(flag!='Y') {
					style +='background-color:#f64c60;'	//#F4F6F5
				}
				return style;
			}
		},
		formatter:function(value,row,index){
			if(value) {
				return value.split('^')[0];
			}
		}
	};
	var ListColumns=[[ 
		{field:'LocDesc',title:'科室',align:'center',width:200,resizable:true},
		{field:'ResDesc',title:'医生',align:'center',width:150,resizable:true},
		{field:'ServiceGroup',title:'服务组',align:'center',width:90,resizable:true},
		{field:'TimeRange',title:'时段',align:'center',width:90,resizable:true},
		$.extend({},weekObj,{field:'Week1',title:'星期一'}),
		$.extend({},weekObj,{field:'Week2',title:'星期二'}),
		$.extend({},weekObj,{field:'Week3',title:'星期三'}),
		$.extend({},weekObj,{field:'Week4',title:'星期四'}),
		$.extend({},weekObj,{field:'Week5',title:'星期五'}),
		$.extend({},weekObj,{field:'Week6',title:'星期六'}),
		$.extend({},weekObj,{field:'Week7',title:'星期日'}),
		{field:'RowId',hidden:true},
		{field:'LocRowid',hidden:true},
		{field:'DocRowid',hidden:true},
		{field:'TimeRangeDr',hidden:true},
		{field:'ServiceGroupID',hidden:true}
    ]]
    var ScheduleTemplateListDataGrid=$("#tabCureRBCResPlan").datagrid({
		fit : true,
		border:false,
		width : 'auto',
		autoRowHeight:false,
		striped : false,
		singleSelect : true,
		fitColumns : true, 
		nowrap:true,
		url : $URL+"?ClassName="+PageLogicObj.m_ClassName+"&QueryName="+PageLogicObj.m_QueryName+"&rows=9999",
		loadMsg : '加载中..',
		pagination : true, 
		rownumbers : false, 
		idField:"RowId",
		pageSize:30,
		pageList : [30,50,100,200],
		columns :ListColumns,
		toolbar :"#tb",
		onBeforeLoad:function(param){
			var UserHospID=Util_GetSelHospID();
			$.extend(param,{LocRowid:getValue('Loc_Search'),UserRowid:session['LOGON.USERID'],
			ResourceId:getValue('Doc_Search'),ILocDesc:"",IDocDesc:"",HospId:UserHospID});
		},
		onLoadSuccess:function(data){
			MergeCell(data,0,data.rows.length-1,"LocDesc");
			InitDragItem();
		},
		onClickCell:function(rowIndex, field, value){
			if(field.indexOf("Week")==-1) return;
			var eve = event||window.event;
			var target = eve.target||eve.srcElement;
			var $obj=$(target);
			if(target.nodeName=="DIV") $obj=$(target).parent();
			value=$obj.text();
			var DataArr=$(this).datagrid('getData');
			var LocResRowid=DataArr.rows[rowIndex].RowId.split("^")[0];;
			var ClickType=$("input[name='ClickType']:checked").val();
			//维护模板
			if(ClickType=='1'){
				var LocRowid=DataArr.rows[rowIndex].LocRowid;
				var DocRowid=DataArr.rows[rowIndex].DocRowid;
				var TimeRange=DataArr.rows[rowIndex].TimeRange;
				var ServiceGroup=DataArr.rows[rowIndex].ServiceGroup;
				var Week="",WeekIndex="";
				for(var i=0;i<ListColumns[0].length;i++){
					if(ListColumns[0][i].field==field){
						Week=ListColumns[0][i].title;
						WeekIndex=field.replace("Week","");
						break;
					}
				}
				if(value=="") {
					var TimeRange=DataArr.rows[rowIndex].TimeRangeDr;
					var ServiceGroup=DataArr.rows[rowIndex].ServiceGroupID;
					var Week=WeekIndex;
					//新增模板
					PageLogicObj.m_AddFlag=1;
				}else{
					PageLogicObj.m_AddFlag=0;
				}
				
				ResClick(LocResRowid,LocRowid,DocRowid,Week,TimeRange,ServiceGroup);
			}else if(ClickType=='2'){ //模板激活/取消激活
				if(value=="") return;
				var WeekNo=field.split("Week")[1];
				var TimeRange=DataArr.rows[rowIndex].RowId.split("^")[1];
				var ServiceGroup=DataArr.rows[rowIndex].RowId.split("^")[2];
				var UserHospID=Util_GetSelHospID();
				var ret=tkMakeServerCall(PageLogicObj.m_ClassName,"ActiveSess",LocResRowid,WeekNo,TimeRange,ServiceGroup,UserHospID);
				if(ret=='0'){
					var Info="激活模板成功!";
					if ($obj.hasClass('inactive')||($obj.attr('style'))){
						$obj.removeAttr("style");
						$obj.removeClass('inactive');
					}else{
						$obj.addClass('inactive');
						Info="取消"+Info;
					}					
					$.messager.popover({msg: Info,type:'success'});
				}else{
					$.messager.alert('提示', "激活/取消激活失败:"+ret);
				}
			}
		}
	});
	return ScheduleTemplateListDataGrid;
}
function MergeCell(Data,StartIndex,EndIndex,Field){
	if(StartIndex==EndIndex) return;
	var InfoObj={Index:StartIndex,Rows:1,Value:""};
	for(var i=StartIndex;i<=EndIndex;i++){
		var cmd="var value=Data.rows[i]."+Field;
		eval(cmd);
		if(i==StartIndex){
			InfoObj.Value=value;
			continue;
		}
		if((InfoObj.Value==value)&&(EndIndex!=i)){
			InfoObj.Rows+=1;
		}else{
			if((EndIndex==i)&&(InfoObj.Value==value)) InfoObj.Rows+=1;
			if(InfoObj.Rows>1){
				$('#tabCureRBCResPlan').datagrid('mergeCells',{
					index:InfoObj.Index,
					field:Field,
					rowspan:InfoObj.Rows
				});
				if(Field=="LocDesc") 
					MergeCell(Data,InfoObj.Index,InfoObj.Index+InfoObj.Rows-1,'ResDesc');
				else if(Field=="ResDesc") 
					MergeCell(Data,InfoObj.Index,InfoObj.Index+InfoObj.Rows-1,'ServiceGroup');
			}	
			InfoObj={Index:i,Rows:1,Value:value};
		}
	}
}
function InitDragItem(){
	var DragDisabled=true;
	var ClickType=$("input[name='ClickType']:checked").val();
	if(ClickType==3) DragDisabled=false;
	var DragObj={
		revert:true,
		disabled:DragDisabled,
		proxy:function(source){
			var p = $('<div style="border:1px solid #ccc"></div>');
			p.html($(source).html()).appendTo('body');
			return p;
		}
	};
	$('.datagrid-body [class*="datagrid-'+ServerObj.datagridCellName+'-Week"]').parent().each(function(){
		var that=this;
		(function(that,theDragObj){
			if($(that).text()!=""){
				$(that).draggable(theDragObj);
			}else{
				$(that).droppable({
					onDrop:function(e,source){
						var UserHospID=Util_GetSelHospID();
						var className=$(source).children()[0].className;
						var WeekNo=Number(className.charAt(className.length-1));
						var RowId=$(source).parent().find('.datagrid-'+ServerObj.datagridCellName+'-RowId').text();
						var LocResRowid=RowId.split("^")[0];
						var CopyFromTimeRange=RowId.split("^")[1];
						var CopyFromServiceGroupDR=RowId.split("^")[2];
						var PlanRowid=tkMakeServerCall(PageLogicObj.m_ClassName,'GetResDataWeeks',LocResRowid,WeekNo,CopyFromTimeRange,CopyFromServiceGroupDR,UserHospID);
						if (PlanRowid=="") return false;
						var theObj=$(that);
						var theParObj=$(that).parent();
						var AddType="CopyAdd";
						new Promise(function(resolve,rejected){
							SetResSessData(PlanRowid,AddType,resolve);
						}).then(function(ResSessData){
							var ResLocID="";
							if (ResSessData!=""){
								var RetArr=ResSessData.split("^");
								var ResLocID=RetArr[0];
							}
							var LocRowid=theParObj.find('.datagrid-'+ServerObj.datagridCellName+'-LocRowid').text();
							var DocRowid=theParObj.find('.datagrid-'+ServerObj.datagridCellName+'-DocRowid').text();
							var className=theObj.children()[0].className;
							var WeekNo=Number(className.charAt(className.length-1));
							var RowId=theParObj.find('.datagrid-'+ServerObj.datagridCellName+'-RowId').text();
							var TimeRange=RowId.split("^")[1];
							var ServiceGroupDR=RowId.split("^")[2];
							var DOWArr=$("#DayOfWeek").combobox('getData');
							var WeekId=DOWArr[WeekNo-1].WeekId;
							$("#DayOfWeek").combobox("setValue",WeekId);
							$("#ServiceGroup").combobox("select",ServiceGroupDR);
							//SetTimeDescList(ServiceGroupDR,"TimeDesc");
							$("#TimeDesc").combobox("select",TimeRange);
							$("#LocList").combobox("select",LocRowid);
							$("#ResourceList").combobox("setValue",DocRowid);
						
							var ret=SaveClick(AddType,CopyFromTimeRange,CopyFromServiceGroupDR,PlanRowid);
							if(ret){
								$.messager.popover({msg: "复制模板成功!",type:'success'});
								$(that).html($(source).html());
								$(that).children().attr('class',className)
								$(that).droppable('disable');
								$(that).draggable($.extend({},theDragObj,{disabled:false,proxy:""}));
								PageLogicObj.m_AddFlag=0;
								ResClick(RowId.split("^")[0],LocRowid,DocRowid,WeekNo,$("#TimeDesc").combobox("getText"));
								setTimeout(function(){
									var sweek=DOWArr[WeekNo-1]['WeekName'];
									var ssg=$("#ServiceGroup").combobox("getText");
									var std=$("#TimeDesc").combobox("getText");
									$('#tabWeek').tabs('select',sweek);
									$('#tabServiceGroup').tabs('select',ssg);
									$('#tabTimeRange').tabs('select',std);
								},100)
							}
							return ret;
						})
					}
				});
				$("td .droppable").unbind("mousedown");
			}
		})(that,DragObj);
	});
	//$(document).unbind("mousedown");
}
function ResClick(LocResRowid,LocRowid,DocRowid,Week,TimeRange,ServiceGroup)
{
	$("#tips").html("");
	$("#BtnSave,#BtnDelete,#BtnAdd,#tabWeek,#tabTimeRange,#tabServiceGroup").show();
	var WinTitle="修改计划模板";
	if (PageLogicObj.m_AddFlag=="1"){
		WinTitle="增加计划模板";
		if (LocResRowid!=""){
			ClearTabs('tabWeek');
			ClearTabs('tabServiceGroup');
			ClearTabs('tabTimeRange');
			$("#LocList").combobox("disable").combobox("select",LocRowid);
			$("#ResourceList").combobox("disable").combobox("select",DocRowid);
			setTimeout(function(){
				$("#TimeRangeFlag").checkbox('uncheck');
				$("#StartTime,#EndTime,#EndAppointTime").timespinner('setValue','');
				$("#Max").numberbox('setValue','').numberbox("validate"); 
				$("#TimeDesc,#ServiceGroup").combobox('setValue','');
				$("#ServiceGroup").combobox('select',ServiceGroup);
				$("#TimeDesc").combobox('select',TimeRange);
				$("#DayOfWeek").combobox('setValue',Week);
				$("#ActiveFlag").checkbox('check');
			},500);
		}else{
			$("#LocList,#ResourceList").combobox("setText","");
			$("#LocList,#ResourceList").combobox("select","").combobox("enable");
			if(ServerObj.ToLocFlag=="Y"){
				var data=$("#LocList").combobox("getData");
				for(var i=0;i<data.length;i++){
			    	if(data[i].LocId==PageLogicObj.m_LogLocID){
				    	$("#LocList").combobox("select",PageLogicObj.m_LogLocID).combobox("disable");
				    }
			    }
			}	
			$("#ResourceList").combobox("loadData",[]);
			$("#TimeDesc").combobox("loadData",[]);
			ClearTabs('tabWeek');
			ClearTabs('tabTimeRange');
			setTimeout(function(){
				$("#TimeRangeFlag").checkbox('uncheck');
				$("#StartTime,#EndTime,#EndAppointTime").timespinner('setValue','');
				$("#Max").numberbox('setValue','').numberbox("validate"); 
				$("#ServiceGroup").combobox('select',"");
				$("#TimeDesc,#ServiceGroup").combobox('setValue','');
				$("#DayOfWeek").combobox('setValue',"");
				$("#ActiveFlag").checkbox('check');
			},500);
		}
		$("#BtnSave,#BtnDelete,#tabWeek,#tabTimeRange,#tabServiceGroup").hide();
	}else{
		$("#LocList").combobox("disable").combobox("select",LocRowid);
		SetDocList(LocRowid,'ResourceList');
		$("#ResourceList").combobox("disable").combobox("select",DocRowid);
		$("#TimeDesc").combobox("loadData",[]);
		setTimeout(function(){
			LoadWeekTabs(LocResRowid,Week,TimeRange,ServiceGroup)},10);
	}
	//$("#ApptMax,#EStartPrefix").attr("disabled",true);
	if ($("#SessEditWindow").hasClass('window-body')){
		$('#SessEditWindow').window('open'); //window('setTitle',WinTitle).
	}else{
		InitWindow(WinTitle);
	}
	setTimeout(function(){
		if (LocResRowid!=""){
			var selLoc=$("#LocList").combobox("getText");
			var selDoc=$("#ResourceList").combobox("getText");
			//var oldTitle=$('#SessEditWindow').window('options').title;
			$('#SessEditWindow').window('setTitle',WinTitle+" <font color='yellow'>"+selLoc+"  "+selDoc+"<font>");
		}
	},1500)
	return;
}
function InitWindow(WinTitle){
	$('#SessEditWindow').window({
		title: WinTitle,
		zIndex:9999,
		iconCls:'icon-w-edit',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true,
		onBeforeClose:function(){
			$('#tabWeek,#tabTimeRange').tabs({
				onSelect:function (){
				}
			})
			ClearTabs('tabWeek');
			ClearTabs('tabTimeRange');
			$('#SessEditWindow').window('setTitle','');
			clearTimeout(PageLogicObj.m_LoadSessTimer);
			LoadCureRBCResPlanDataGrid();
			PageLogicObj.m_AddFlag=0;
			InitDOWTabs();
			InitTRTabs();
		}			
	});
}
function SetTimeDescList(SGID,ID){
	$("#"+ID).combobox('select','');
	var HospID=Util_GetSelHospID();
	var rs=$cm({
		ClassName:PageLogicObj.m_ClassName,
		QueryName:"QueryBookTime",
		HospID:HospID,
		SGRowID:SGID,
		ResultSetType:"array",
		rows:99999
	},false);
	$("#TimeDesc").combobox("loadData",rs);
}

function SetDocList(LocID,ID){
	var url=$URL+'?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID='+LocID+'&ResultSetType=array';
	$("#"+ID).combobox('setValue','');
	$("#"+ID).combobox('reload',url);
}

function InitSingleCombo(id,valueField,textField,Query,multipleField,ClassName){
	if((typeof(multipleField)=="undefined")||(multipleField=="")){
		multipleField=false
	}
	if (typeof(ClassName)=="undefined") ClassName="";
	var HospID=Util_GetSelHospID();
	var ComboObj={
		editable:true,
		panelHeight:200,
		multiple:multipleField,
		mode:"local",
		method: "GET",
	  	valueField:valueField,   
	  	textField:textField,
	  	url:$URL+'?ClassName='+(ClassName==""?PageLogicObj.m_ClassName:ClassName)+'&QueryName='+Query+'&HospId='+HospID+"&HospID="+HospID+'&ResultSetType=array',
	  	filter: function(q, row){
		  	if (q=="") return true;
		  	var opts = $(this).combobox('options');
			return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0)||((row['code'])&&(row['code'].toUpperCase().indexOf(q.toUpperCase()) >= 0))||((row['LocContactName'])&&(row['LocContactName'].toUpperCase().indexOf(q.toUpperCase()) >= 0));
		}
	};
	if(id=="LocList"){
		$.extend(ComboObj,{
			onSelect:function(record){
				if (record!=undefined){
					SetDocList(record.LocId,"ResourceList");
				}
			},onBeforeLoad:function(param){
				if(ServerObj.ToLocFlag=="Y"){
					$.extend(param,{LogLocID:PageLogicObj.m_LogLocID});
				}	
			},onLoadSuccess:function(data){
				if(ServerObj.ToLocFlag=="Y"){
					for(var i=0;i<data.length;i++){
				    	if(data[i].LocId==PageLogicObj.m_LogLocID){
					    	$(this).combobox("select",PageLogicObj.m_LogLocID).combobox("disable");
					    }
				    }
				}	
			}
		});
	}else if(id=="ResourceList"){
		$.extend(ComboObj,{
			onSelect:function(record){
				if (record!=undefined){
				}
			}
		});
	}else if(id=="Loc_Search"){
		$.extend(ComboObj,{
			onSelect:function(record){
				SetDocList(record.LocId,"Doc_Search");
				setTimeout(function(){LoadCureRBCResPlanDataGrid()},100);
			},onBeforeLoad:function(param){
				if(ServerObj.ToLocFlag=="Y"){
					$.extend(param,{LogLocID:PageLogicObj.m_LogLocID});
				}	
			},onLoadSuccess:function(data){
				if(ServerObj.ToLocFlag=="Y"){
					for(var i=0;i<data.length;i++){
				    	if(data[i].LocId==PageLogicObj.m_LogLocID){
					    	$(this).combobox("select",PageLogicObj.m_LogLocID).combobox("disable");
					    }
				    }
				}	
			}
		});
	}else if(id=="Doc_Search"){
		$.extend(ComboObj,{
			onSelect:function(record){
				LoadCureRBCResPlanDataGrid();
			}
		});
	}else if(id=="ServiceGroup"){
		$.extend(ComboObj,{
			onSelect:function(record){
				if (record!=undefined){
					SetTimeDescList(record.Rowid,"TimeDesc");
				}
			}
		});
	}else if(id=="TimeDesc"){
		$.extend(ComboObj,{
			editable:false,
			onSelect:function(record){
				if ((record!=undefined)&&(record!="")){
					var Rowid=record.Rowid;
					var StartTime=record.StartTime;
					var EndTime=record.EndTime;
					var EndChargTime=record.EndChargTime;
					var EndAppointTime=record.EndAppointTime;
					SetValue("StartTime",StartTime);
					SetValue("EndTime",EndTime);
					SetValue("EndAppointTime",EndAppointTime);
					/*if($("#TimeRangeFlag").checkbox('getValue')){
						SetValue("TRStartTime",StartTime);
						SetValue("TREndTime",EndTime);
					}else{
						SetValue("TRStartTime","");
						SetValue("TREndTime","");
					}*/
					$HUI.timespinner("#StartTime").disable();
					$HUI.timespinner("#EndTime").disable();
					//$HUI.timespinner("#EndAppointTime").disable();
					TRInfoCalculateHandle("N");
				}else{
					$("#StartTime,#EndTime,#EndAppointTime").val("");
					//SetValue("TRStartTime","");
					//SetValue("TREndTime","");
				}
			}
		});
	}
	$("#"+id).combobox(ComboObj);
}

function ClearTabs(ID){
	var tabs=$('#'+ID).tabs('tabs');
	for(var i=tabs.length;i>0;i--){
		var index = $('#'+ID).tabs('getTabIndex',tabs[i-1]);
		$('#'+ID).tabs('close',index);
	}
}
function LoadWeekTabs(Rowid,DefWeek,DefTimeRange,DefServiceGroup){
	PageLogicObj.m_SelectTimeRange=DefTimeRange;
	PageLogicObj.m_SelectSG=DefServiceGroup;
	ClearTabs('tabWeek');
	var UserHospID=Util_GetSelHospID();
	var DOWStr=tkMakeServerCall(PageLogicObj.m_ClassName,"GetResDataWeeks",Rowid,"","","",UserHospID);
	var DOWArr=DOWStr.split("^");
	for(var i=0;i<DOWArr.length;i++){
		var title=DOWArr[i].split(":")[0];
		var id=DOWArr[i].split(":")[1];
		var tabWeekObj={id:id,title:title,closable:false,selected:false};
		if((DefWeek!=undefined)&&(DefWeek!="")&&(title==DefWeek)) $.extend(tabWeekObj,{selected:true});
		else if(i==0) $.extend(tabWeekObj,{selected:true});
		$('#tabWeek').tabs('add',tabWeekObj); 
	}
}

function InitDOWTabs(){
	$('#tabWeek').tabs({
		selected:'',
		tabWidth:'90px',
		onSelect:function(title,index){
			$('#tabServiceGroup').tabs({
				onSelect:function (){
				}
			});
			ClearTabs('tabServiceGroup');
			InitSGTabs();
			var tab=$(this).tabs('getTab',index);
			var id=tab[0].id;
			var SGArr=id.split("#");
			for(var i=0;i<SGArr.length;i++){
				var tabSGObj={id:SGArr[i].split("@")[1],title:SGArr[i].split("@")[0],closable:false,selected:false};
				if(PageLogicObj.m_SelectSG==tabSGObj.title) $.extend(tabSGObj,{selected:true});
				else if((i==0)&&(PageLogicObj.m_SelectSG=="")) $.extend(tabSGObj,{selected:true});
				$('#tabServiceGroup').tabs('add',tabSGObj); 
			}
			var selTab=$('#tabServiceGroup').tabs('getSelected');
			if (!selTab){
				var tabs=$('#tabServiceGroup').tabs('tabs');
				if (tabs.length>0) {
					$('#tabServiceGroup').tabs('select',0); 
				}
			}
		},
		onContextMenu:function(e, title,index){
			e.preventDefault(); //阻止浏览器捕获右键事件
			$('#mm-week').menu('show', {
		       left: e.pageX,
		       top: e.pageY,
		     });
		}
		
	});
}

function InitSGTabs(){
	$('#tabServiceGroup').tabs({
		selected:'',
		//tabWidth:'100px',
		onSelect:function(title,index){
			$('#tabTimeRange').tabs({
				onSelect:function (){
				}
			});
			ClearTabs('tabTimeRange');
			InitTRTabs();
			var tab=$(this).tabs('getTab',index);
			var id=tab[0].id;
			var TRArr=id.split(String.fromCharCode(2));
			for(var i=0;i<TRArr.length;i++){
				var tabTRObj={id:TRArr[i].split(String.fromCharCode(1))[1],title:TRArr[i].split(String.fromCharCode(1))[0],closable:false,selected:false};
				if(PageLogicObj.m_SelectTimeRange==tabTRObj.title) $.extend(tabTRObj,{selected:true});
				else if((i==0)&&(PageLogicObj.m_SelectTimeRange=="")) $.extend(tabTRObj,{selected:true});
				$('#tabTimeRange').tabs('add',tabTRObj); 
			}
			var selTab=$('#tabTimeRange').tabs('getSelected');
			if (!selTab){
				var tabs=$('#tabTimeRange').tabs('tabs');
				if (tabs.length>0) {
					$('#tabTimeRange').tabs('select',0); 
				}
			}
		},
		onContextMenu:function(e, title,index){
			e.preventDefault(); //阻止浏览器捕获右键事件
			$('#mm-servicegroup').menu('show', {
		       left: e.pageX,
		       top: e.pageY,
		     });
		}
	});
}

function InitTRTabs(){
	$('#tabTimeRange').tabs({
		selected:'',
		//tabWidth:'100px',
		onSelect:function(title,index){
			var tab=$(this).tabs('getTab',index);
			var PlanRowid=tab[0].id;
			clearTimeout(PageLogicObj.m_LoadSessTimer);
			PageLogicObj.m_LoadSessTimer=setTimeout(function(){SetResSessData(PlanRowid)},50);
		}
	});
}

function SetResSessData(PlanRowid,AddType,callBackFun){
	if(PlanRowid) $("#BtnSave").show();
	else $("#BtnSave").hide();
	var RetData="";
	if (PlanRowid!=""){
		var RetData=tkMakeServerCall(PageLogicObj.m_ClassName,"GetSessData",PlanRowid);
		var SessArr=RetData.split("^");
		$("#Max").numberbox('setValue',SessArr[12]).numberbox("validate"); //.focus()
		$('#DayOfWeek').combobox('setValue',SessArr[4]);
		$('#ServiceGroup').combobox('select',SessArr[10]);
		//$('#TimeDesc').combobox('setValue',SessArr[6]);
		var GenerFlag=SessArr[17];
		if(GenerFlag=="Y") $('#ActiveFlag').checkbox('check');
		else $('#ActiveFlag').checkbox('uncheck');
		//else if (GenerFlag=="N") $('#ActiveFlag').checkbox('uncheck');
		var TimeRangeFlag=(SessArr[19]=="Y");
		$("#TimeRangeFlag").checkbox("setValue",TimeRangeFlag);
		$("#TRLength").numberbox("setValue",SessArr[20]);
		$("#ReservedNum").numberbox("setValue",SessArr[21]);
		//$HUI.timespinner("#EndAppointTime").disable();
		SetTimeDescList(SessArr[10],"TimeDesc");
		SetValue("TimeDesc",SessArr[6],"时段");
		setTimeout(function(){
			$HUI.timespinner("#EndAppointTime").setValue(SessArr[18]);
			$HUI.timespinner("#StartTime").setValue(SessArr[8]);
			$HUI.timespinner("#EndTime").setValue(SessArr[9]);
			$("#StartTime,#EndTime").timespinner("disable");
		},10)
	}else{
		$("#Max").numberbox('setValue','');
		$('#ScheduleGenerFlag').checkbox('check');
		$('#ActiveFlag').checkbox('uncheck');
		$("#StartTime,#EndTime,#EndAppointTime").timespinner("setValue","");
		$("#TimeDesc").combobox("loadData",[]);
		$("#TimeRangeFlag").checkbox("setValue",false);
		$("#TRLength").numberbox("setValue","");
		$("#ReservedNum").numberbox("setValue","");
		$("#DayOfWeek,#TimeDesc,#ServiceGroup").combobox("setValue",'').combobox("setText",'');
	}
	new Promise(function(resolve,rejected){
		if(AddType!="CopyAdd"){
			LoadTabAppQtyListDataGrid(PlanRowid,resolve,"Plan");
		}else{
			resolve();
		}
	}).then(function(){
		if(typeof callBackFun == "function"){
			callBackFun(RetData);	
		}
		return RetData;
	})
}

function DeleteSessByServiceGroup(){
	var tabServiceGroup = $('#tabServiceGroup').tabs('getSelected');
	var ServiceGroup=tabServiceGroup.panel("options").title;
	var index = $('#tabServiceGroup').tabs('getTabIndex',tabServiceGroup);
	$.messager.confirm("提示", "是否删除 <font color='red'>"+ServiceGroup+"</font> 下所有时段模板?", function (data) {
		if (data) {
			var tabs = $('#tabTimeRange').tabs('tabs');
			for (var i=0;i<tabs.length;i++){
				var PlanRowid=tabs[i][0].id;
				var ret = tkMakeServerCall(PageLogicObj.m_ClassName,"DeleteCureRBCResPlan",PlanRowid);
			}
			if (ret=='0'){
				$.messager.popover({msg: '删除成功!',type:'success'});
				$('#tabServiceGroup').tabs('close',index);
			}
		}
	});
}

function DeleteSessByWeek(){
	var tabweek = $('#tabWeek').tabs('getSelected');
	var week=tabweek.panel("options").title;
	var index = $('#tabWeek').tabs('getTabIndex',tabweek);
	$.messager.confirm("提示", "是否删除 <font color='red'>"+week+"</font> 下所有服务组的模板?", function (data) {
		if (data) {
			var aret=0;
			var trtabs = $('#tabServiceGroup').tabs('tabs');
			for (var i=0;i<trtabs.length;i++){
				$('#tabTimeRange').tabs('select',i)
				var tabs = $('#tabTimeRange').tabs('tabs');
				for (var j=0;j<tabs.length;j++){
					var PlanRowid=tabs[j][0].id;
					var ret = tkMakeServerCall(PageLogicObj.m_ClassName,"DeleteCureRBCResPlan",PlanRowid);
				}
				if (ret=='0'){
					//$.messager.popover({msg: '删除成功!',type:'success'});
					$('#tabServiceGroup').tabs('close',i);
				}else{
					aret=-1;	
				}
			}
			if (aret=='0'){
				$.messager.popover({msg: '删除成功!',type:'success'});
				$('#tabWeek').tabs('close',index);
			}
		}
	});
}

function DeleteSess(){
	$.messager.defaults = { ok: "是", cancel: "否" };
	var tab = $('#tabTimeRange').tabs('getSelected');
	var TimeRange=tab.panel("options").title;
	var tabweek = $('#tabWeek').tabs('getSelected');
	var week=tabweek.panel("options").title;
	var tabServiceGroup = $('#tabServiceGroup').tabs('getSelected');
	var ServiceGroup=tabServiceGroup.panel("options").title;
	$.messager.confirm("提示", "是否删除 <font color='red'>"+week+" "+ServiceGroup+" "+TimeRange+"</font> 的模板?", function (data) {
		if (data) {
			var tab = $('#tabTimeRange').tabs('getSelected');
			var PlanRowid=tab[0].id;
			var ret = tkMakeServerCall(PageLogicObj.m_ClassName,"DeleteCureRBCResPlan",PlanRowid);
			if(ret=='0'){
				$.messager.popover({msg: '删除成功!',type:'success'});
				var index = $('#tabTimeRange').tabs('getTabIndex',tab);
				$('#tabTimeRange').tabs('close',index);
				var tab = $('#tabTimeRange').tabs('getSelected');
				if(!tab){
					var tab = $('#tabServiceGroup').tabs('getSelected');
					var index = $('#tabServiceGroup').tabs('getTabIndex',tab);
					$('#tabServiceGroup').tabs('close',index);
					var tab = $('#tabServiceGroup').tabs('getSelected');
					if(!tab){
						var tab = $('#tabWeek').tabs('getSelected');
						var index = $('#tabWeek').tabs('getTabIndex',tab);
						$('#tabWeek').tabs('close',index);
					}
				}
			}else{
				$.messager.alert("提示","删除失败:"+ret);
			}
		}
	});
}

function MergeExcelCell(xlsheet,TotalCols,CurrentCol,StartRow,EndRow){
	var ColName=String.fromCharCode(64+CurrentCol);
	var OldVal="",OldRow=StartRow;
	for(var i=StartRow;i<=EndRow;i++){
		var CellVal=xlsheet.cells(i,CurrentCol).Value;
		if(((i-OldRow)>1)&&((OldVal!=CellVal)||((i==EndRow)&&(CellVal==OldVal)))){
			var row=i-1;
			if(i==EndRow) row=i;
			xlsheet.Cells(row,CurrentCol).ClearContents;
			xlsheet.Range(ColName+OldRow+":"+ColName+row).MergeCells = true;
			var NewCol=CurrentCol+1;
			if(NewCol<=TotalCols)
				MergeExcelCell(xlsheet,TotalCols,NewCol,OldRow,row);
			OldVal=CellVal,OldRow=i;
		}else{
			if(CellVal!=OldVal) OldRow=i,OldVal=CellVal;
			else xlsheet.Cells(i,CurrentCol).ClearContents;
		}
	}	
}

function SaveClick(Type,CopyFromTimeRange,CopyFromServiceGroupDR,CopyFromSessRowid)
{
	if(!CheckBeforeSave(Type)) return false;
	var Rowid=$("#Rowid").val();
	var LocId=$('#LocList').combobox('getValue');
	var ResourceId=$('#ResourceList').combobox('getValue');   
	var Week=$('#DayOfWeek').combobox('getValue');
	var TimeDesc=$('#TimeDesc').combobox('getValue');
	var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	var StartTime=$("#StartTime").val();
	var EndTime=$("#EndTime").val();
	var Max=$("#Max").val();
	var AutoNumber=""; //$("#AutoNumber").val();
	var ChargTime="";
	var EndAppointTime=$("#EndAppointTime").val();
	var GenerFlag="N";
	if($("#ActiveFlag").checkbox('getValue')) GenerFlag="Y";
	var LocResRowid=LocId+"||"+ResourceId;
	var TimeRangeInfo=GetTRInfo();
	
	if(TimeRangeInfo==false){	
		if(Type=="CopyAdd"){
			$.messager.popover({
				msg: '分时段信息复制失败,获取分时段信息错误,请检查分时段信息维护是否正确。',
				type: 'error',
				timeout: 5000,
				showSpeed: 'slow', 
				style: {
					top:document.body.scrollTop + document.documentElement.scrollTop+10,
					right:$(window).width()*0.5-250
				}
			});
			TimeRangeInfo="";
		}else{
			return false;
		}
	}
	var InputPara=Rowid+"^"+LocId+"^"+ResourceId+"^"+Week+"^"+TimeDesc;
	var InputPara=InputPara+"^"+ServiceGroup+"^"+StartTime+"^"+EndTime+"^"+Max+"^"+AutoNumber;
	var InputPara=InputPara+"^"+ChargTime+"^"+GenerFlag+"^"+EndAppointTime;
	if ((Type=="Add")||(Type=="CopyAdd")){
		var InputParaArr=InputPara.split("^");
		InputParaArr[0]="";
		InputPara=InputParaArr.join("^");
		var value=$.cm({
			ClassName:"DHCDoc.DHCDocCure.RBCResPlan",
			MethodName:"SaveCureRBCResPlan",
			value:InputPara,
			TimeRangeInfo:TimeRangeInfo,
			dataType:"text"
		},false)
	}else if(Type=="Update"){
		var tab = $('#tabTimeRange').tabs('getSelected');
		var Rowid=tab[0].id;
		var InputParaArr=InputPara.split("^");
		InputParaArr[0]=Rowid;
		InputPara=InputParaArr.join("^");
		var value=$.cm({
			ClassName:"DHCDoc.DHCDocCure.RBCResPlan",
			MethodName:"SaveCureRBCResPlan",
			value:InputPara,
			TimeRangeInfo:TimeRangeInfo,
			dataType:"text"
		},false)	
	}
	if(value=="0"){
		$.messager.popover({msg: '保存成功!',type:'success',timeout: 3000})
		LoadCureRBCResPlanDataGrid();
	}else{
		var errmsg="";
		if (value==100)errmsg=",必填数据不能为空或者不合法";
		else if (value==101)errmsg=",已经存在同时段的模板,不能重复添加";
		else errmsg=value;
		$.messager.alert("错误","保存失败"+errmsg,"error")
		return false;
	}
	var Week=$("#DayOfWeek").combobox("getText");
	var TimeRange=$("#TimeDesc").combobox("getText");
	var ServiceGroup=$("#ServiceGroup").combobox("getText");
	$("#BtnSave,#BtnDelete,#BtnAdd,#tabWeek,#tabTimeRange,#tabServiceGroup").show();
	LoadWeekTabs(LocResRowid,Week,TimeRange,ServiceGroup);
	return true;
	
}

function CheckBeforeSave(Type)
{
	var LocId=getValue("LocList");	//$('#LocList').combobox('getValue');
	var LocId=CheckComboxSelData("LocList",LocId);
	if(LocId=="")
	{
		$.messager.alert("提示", "请选择科室", 'warning',function(){
			$('#LocList').next('span').find('input').focus();
		})
		return false;
	}
	var ResourceId=$('#ResourceList').combobox('getValue');
	//var ResourceId=CheckComboxSelData("ResourceList",ResourceId);
	if(ResourceId=="")
	{
		$.messager.alert("提示", "请选择资源", 'warning',function(){
			$('#ResourceList').next('span').find('input').focus();
		});
		return false;
	}
	var Week=getValue("DayOfWeek");	//$('#DayOfWeek').combobox('getValue');
	var Week=CheckComboxSelData("DayOfWeek",Week);
	if(Week=="")
	{
		$.messager.alert('提示','请选择星期', 'warning',function(){
			$('#DayOfWeek').next('span').find('input').focus();
		});
        return false;
	}
	var ServiceGroup=getValue("ServiceGroup");	//$('#ServiceGroup').combobox('getValue');
	var ServiceGroup=CheckComboxSelData("ServiceGroup",ServiceGroup);
	if(ServiceGroup=="")
	{
		$.messager.alert('提示','请选择服务组',"warning",function(){
			$('#ServiceGroup').next('span').find('input').focus();
		});
        return false;
	}
	var TimeDesc=getValue("TimeDesc");	//$('#TimeDesc').combobox('getValue');
	var TimeDesc=CheckComboxSelData("TimeDesc",TimeDesc);
	if(TimeDesc=="")
	{
		if ((Type=="CopyAdd")){
			$.messager.alert('提示','当前复制到的时段对应服务组不可用,请确认服务组与时段是否已关联.', 'warning');
		}else{
			$.messager.alert('提示','请选择时段', 'warning',function(){
				$('#TimeDesc').next('span').find('input').focus();
			});
		}
		
        return false;
	}
	var StartTime=$("#StartTime").val();
	if(StartTime=="")
	{
		$.messager.alert('提示','请填写开始时间',"warning");   
        return false;
	}
	var EndTime=$("#EndTime").val();
	if(EndTime=="")
	{
		$.messager.alert('提示','请填写结束时间',"warning");   
        return false;
	}
	var Max=$("#Max").val();
	if(Max=="")
	{
		$.messager.alert('提示','请填写最大预约数',"warning",function(){
			$('#Max').focus();
		}); 
        return false;
	}
	var Max=parseFloat(Max);
	if(Max<=0){
		$.messager.alert("提示","预约数请填写大于0整数","warning");
		return false;	
	}
	var ReservedNum=$("#ReservedNum").numberbox("getValue");
	if ((ReservedNum!="")&&(parseInt(ReservedNum)>parseInt(Max))){
		$.messager.alert('提示','分时段保留号数不能大于最大预约数',"warning");   
        return false;
	}
	return true;	
}

function GenSche(){
	var ScheduleLinesRowId=$("#ScheduleLines_Search").combobox('getValue');
	var src="opadm.schedulegen.hui.csp?ScheduleLinesRowId="+ScheduleLinesRowId;
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("GenSche","生成排班", "410", "700","icon-w-edit","",$code,"");
}
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//如果放大镜文本框的值为空,则返回空值
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		var optobj=$("#"+id).combobox("options");
		var mulval=optobj.multiple;
		if(mulval){
			var tmpval=new Array();
			var val=$("#"+id).combobox("getValues");
			for(var i=0;i<val.length;i++){
				if(val[i]!=""){
					tmpval.push(val[i])
				}
			}
			val=tmpval.join(",");
		}else{
			var val=$("#"+id).combobox("getValue");
			var data=$("#"+id).combobox("getData");
			if ($.hisui.indexOfArray(data,optobj.valueField,val)<0) {
				val="";
			}
		}
		if(typeof val =="undefined") val="";
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}
function CheckComboxSelData(id,selId){
	var Find=0;
	var Data=$("#"+id).combobox('getData');
	for(var i=0;i<Data.length;i++){
		if ((id=="Loc_Search")||(id=="LocList")){
			var CombValue=Data[i].LocId;
			var CombDesc=Data[i].LocDesc;
		}else if ((id=="Doc_Search")||(id=="ResourceList")){
			var CombValue=Data[i].TRowid;
			var CombDesc=Data[i].TResDesc;
		}else if (id=="DayOfWeek"){
			var CombValue=Data[i].WeekId  
			var CombDesc=Data[i].WeekName
		}else{
			var CombValue=Data[i].Rowid  
			var CombDesc=Data[i].Desc
		}
		if(selId==CombValue){
			selId=CombValue;
			Find=1;
			break;
		}
	}
	if (Find=="1") return selId
	return "";
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    com_Util.createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event)
}
function destroyDialog(id){
	com_Util.destroyDialog(id);
}

function Doc_OnKeyDown(e){
	//防止在空白处敲退格键，界面自动回退到上一个界面
   if (!websys_cancelBackspace(e)) return false;
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
}

function LoadCureRBCResPlanDataGrid(){
	$('#tabCureRBCResPlan').datagrid('reload');
}

function ImportTemplate(){
	var ForLocID="";
	if(ServerObj.ToLocFlag=="Y"){
	    ForLocID=PageLogicObj.m_LogLocID;
	}	
	var src="doccure.rbcresplan.import.hui.csp?ForLocID="+ForLocID;
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("importDiag","导入", 850, 545,"icon-w-import","",$code,"");
}

function GenSche(){
	var ForLocID="";
	if(ServerObj.ToLocFlag=="Y"){
	    ForLocID=PageLogicObj.m_LogLocID;
	}	
	var src="doccure.schedulegen.hui.csp?ForLocID="+ForLocID;
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("GenSche","生成资源排程", "410", "700","icon-w-edit","",$code,"");
}

function SetValue(id ,val,desc){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-lookup")>=0){
		
	}else if(className.indexOf("hisui-combobox")>=0){
		var optobj=$("#"+id).combobox("options");
		var mulval=optobj.multiple;
		var data=$("#"+id).combobox("getData");
		if ($.hisui.indexOfArray(data,optobj.valueField,val)<0) {
			$.messager.popover({msg: desc+',当前值不可用,已自动清空',type:'info',timeout: 1000});
			$("#"+id).combobox("select","");
		}else{
			$("#"+id).combobox("select",val);
		}
	}else if(className.indexOf("hisui-datebox")>=0){
		$("#"+id).datebox("setValue",val)
	}else if(className.indexOf("timespinner")>=0){
		$("#"+id).timespinner("setValue",val)
	}else if(className.indexOf("numberbox")>=0){
		$("#"+id).numberbox("setValue",val)
	}else{
		$("#"+id).val(val)
	}
}

function DownLoadClickHandle(){
	$cm({
		ResultSetType:"ExcelPlugin", 
		ExcelName:"治疗排程计划数据导入模板",
		PageName:"CureRBCResPlan",
		ClassName:"DHCDoc.DHCDocCure.OnlineSupport",
		QueryName:"QryResPlanTPL"
	},false);
}