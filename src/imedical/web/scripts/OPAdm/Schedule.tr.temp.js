var tabTRInfo=[]
var tabtempListType=""
var EditRow=undefined
$(function(){
	InitHospList();
    $('#BTRGen').click(TRGenClick);
});
function InitHospList()
{
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		EditRow=undefined;
		$('#tabTempList').datagrid('load');
		$('#tabTempList').datagrid('clearSelections');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitTempTRAMList();
	    InitTempTRList();
	    InitTempList();
	    InitTRWin();
	}
}
function InitTempList()
{
    $('#tabTempList').datagrid({
	    fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		idField:"ID",
		pageList : [15,100,200],
        columns:[[
            {field:'ID',hidden:true},
            {field:'TimeRangeDR',hidden:true},
            {field:'InsertUserDR',hidden:true},
            {field:'Data',hidden:true},
            {field:'TimeRange',title:'时段',align:'center',width:80,
                editor:{type:'combobox',
                    options:{
	                    valueField:"RowId",
	                    textField:"Desc",
                        onSelect:function(record){
                            SetElementValue('SttTime',record.SttTime);
                            SetElementValue('EndTime',record.EndTime);
                        },
                        url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Combo',
						    filter: function(q, row){
						        var opts = $(this).combobox('options');
						        return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
						    },
                        onBeforeLoad:function(param){
                            param.ClassName="web.DHCApptScheduleNew";
                            param.QueryName="LookUpTimeRange";
                            param.date=""
                            param.HospId=$HUI.combogrid('#_HospUserList').getValue();
                            //param.ArgCnt=2;
                        }
                    }
                }
            },
            {field:'Name',title:'模板名称',align:'center',width:150,
                editor:{type:'text'}
            },
            {field:'TempListTypeID',title:'TempListID',align:'center',hidden:true},
            {field:'TempListType',title:'模板权限类型',align:'center',width:100,
               editor:{type:'combobox',
                    options:{
	                    valueField:"ID",
	                    textField:"Desc",
                        data:[{"ID":"HOSP","Desc":"全院"},{"ID":"LOC","Desc":"科室"},{"ID":"USER","Desc":"用户"}],
                        onSelect:function(record){
	                       var rowId=$(this).parents(".datagrid-row")[0].id;
	                       var rowIndex=rowId.split("-")[rowId.split("-").length-1];
	                       tabtempListType= record.ID;
	                       var rows=$('#tabTempList').datagrid("selectRow",rowIndex).datagrid("getSelected");
						   var Editors=$('#tabTempList').datagrid('getEditors',rowIndex);
						   $(Editors[3].target).combogrid("setValue","");
						   //$(Editors[3].target).combogrid('reload');
					       var grid = $HUI.combogrid(Editors[3].target).grid();
					       grid.datagrid("reload");
						   rows.TempListID="";
                        },
	                    onChange:function(newValue,oldValue){
		                    if (!newValue) {
			                    var rowId=$(this).parents(".datagrid-row")[0].id;
	                       		var rowIndex=rowId.split("-")[rowId.split("-").length-1];
			                    var rows=$('#tabTempList').datagrid("selectRow",rowIndex).datagrid("getSelected");
			                    var Editors=$('#tabTempList').datagrid('getEditors',rowIndex);
							    $(Editors[3].target).combogrid("setValue","");
								rows.TempListDesc="";
								rows.TempListID="";
								tabtempListType="";
								var grid = $HUI.combogrid(Editors[3].target).grid();
					       		grid.datagrid("reload");
			                }
		                }
                    }
                }
            },
            {field:'TempListDesc',title:'模板权限',align:'center',width:250,
                editor:{
              		type:'combogrid',
                    options:{
	                    enterNullValueClear:false,
						required: false,
						panelWidth:450,
						panelHeight:350,
						delay:500,
						idField:'ID',
						textField:'Desc',
						value:'',//缺省值 
						mode:'remote',
						pagination : true,//是否分页   
						rownumbers:true,//序号   
						collapsible:false,//是否可折叠的   
						fit: true,//自动大小   
						pageSize: 10,//每页显示的记录条数，默认为10   
						pageList: [10],//可以设置每页记录条数的列表  
						url:$URL+"?ClassName=DHCDoc.OPAdm.TimeRangeTemp&QueryName=QueryTempList",
                        columns:[[
                            {field:'Desc',title:'名称',width:310,sortable:true},
			                {field:'ID',title:'ID',width:100,sortable:true}
                         ]],
						onSelect: function (rowIndex, rowData){
							var rows=$('#tabTempList').datagrid("selectRow",EditRow).datagrid("getSelected");
							rows.TempListID=rowData.ID
						},
						onClickRow: function (rowIndex, rowData){
							var rows=$('#tabTempList').datagrid("selectRow",EditRow).datagrid("getSelected");
							rows.TempListID=rowData.ID
						},
						onLoadSuccess:function(data){
							$(this).next('span').find('input').focus();
						},
						onBeforeLoad:function(param){
							if (tabtempListType==""){
								//return false;
							}
							if (param['q']) {
								var desc=param['q'];
							}
							var Type=tabtempListType
							param = $.extend(param,{Type:Type,Desc:desc,HospID:$HUI.combogrid('#_HospUserList').getValue(),UserID:session['LOGON.USERID']});
						},
	                    onChange:function(newValue,oldValue){
		                    if (!newValue) {
			                    var rowId=$(this).parents(".datagrid-row")[0].id;
	                       		var rowIndex=rowId.split("-")[rowId.split("-").length-1];
			                    var rows=$('#tabTempList').datagrid("selectRow",rowIndex).datagrid("getSelected");
			                    var Editors=$('#tabTempList').datagrid('getEditors',rowIndex);
							    $(Editors[3].target).combogrid("setValue","");
								rows.TempListDesc="";
								rows.TempListID="";
			                }
		                }
            		}
    			  }
            },
            {field:'TempListID',title:'TempListID',align:'center',hidden:true},
            {field:'Load',title:'号源总数',align:'center',width:80},
            {field:'InsertUser',title:'用户',align:'center',width:80},
            {field:'InsertDate',title:'日期',align:'center',width:100},
            {field:'InsertTime',title:'时间',align:'center',width:60},
            {field:'SttTime',hidden:true},
            {field:'EndTime',hidden:true}
        ]],
        toolbar:[{
            text:'增加',
            iconCls:'icon-add',
            handler:function(){
                var date=new Date();
                var y = formatDate(date.getFullYear()),m = formatDate(date.getMonth()+1),d = formatDate(date.getDate());
                var h=formatDate(date.getHours()),min=formatDate(date.getMinutes()),s=formatDate(date.getSeconds());
                if (dtseparator=="/") {
                	var CurrentDate=d+'/'+m+'/'+y,CurrentTime=h+":"+min;
                }else{
	                var CurrentDate=y+'-'+m+'-'+d,CurrentTime=h+":"+min;
	            }
                $('#tabTempList').datagrid('appendRow',{
                    TimeRangeDR:'',
                    InsertUserDR:session['LOGON.USERID'],
                    InsertUser:session['LOGON.USERNAME'],
                    InsertDate:CurrentDate,
                    InsertTime:CurrentTime
                });
                var rows=$('#tabTempList').datagrid('getRows');
                tabtempListType="";
                EditRow = rows.length-1;
                $('#tabTempList').datagrid('beginEdit',rows.length-1);
                function formatDate(num){
                    return num<10?('0'+num):num;
                }
            }
        },{
            text:'删除',
            iconCls:'icon-remove',
            handler:function(){
                var Selected=$('#tabTempList').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"请先选择需要删除的模板!",type:'alert'});
                    return false;
                }
                $.messager.confirm('提示','确定删除此条数据?',function(r){
                    if(r){
	                    if (Selected.ID) {
		                    var ret=tkMakeServerCall('DHCDoc.OPAdm.TimeRangeTemp','Delete',Selected.ID);
		                    DeleteDGTBSaveTip('tabTempList');
		                    $('#tabTempList').datagrid('reload');
		                    EditRow = undefined;
		                    $('#tabTempList').datagrid('unselectAll');
		                }else{
			                var index=$('#tabTempList').datagrid('getRowIndex',Selected);
	                        $('#tabTempList').datagrid('deleteRow',index);
	                        tabTRInfo=[];
				        	SetElementValue('tabTRInfo',[]);
	                    	SetElementValue('tabTRAppMethodInfo',[]);
	                    	$('#tabTRAppMethodInfo').datagrid('clearSelections');
	                    	var ExistEditRowFlag=0;
	                    	var rows=$("#tabTempList").datagrid('getRows');
	                    	for(var i=0;i<rows.length;i++){
			                    var Editors=$('#tabTempList').datagrid('getEditors',i);
			                    if(Editors.length){
			                        ExistEditRowFlag=1;
			                        break;
			                    }
			                }
			                if (ExistEditRowFlag ==0) {
			                	DeleteDGTBSaveTip('tabTempList');
			                }
			                $('#tabTempList').datagrid('unselectAll');
			            }
                    }
                });
            }
        },{
            text:'保存',
            iconCls:'icon-save',
            handler:function(){
                var rows=$("#tabTempList").datagrid('getRows'); //GetElementValue('tabTempList');
                if(!rows.length){
                    $.messager.popover({msg:"没有需要保存的数据!",type:'alert'});
                    return;
                }
                var UnTimeRangeFlag=0;
                var UnNameFlag=0;
                var TimeRangChangeFLag=0
                var ChangeID=""
                for(var i=0;i<rows.length;i++){
                    var Editors=$('#tabTempList').datagrid('getEditors',i);
                    if(Editors.length){
	                    if (GetElementValue(Editors[0].target)!=rows[i].TimeRangeDR){TimeRangChangeFLag=1}
                        rows[i].TimeRangeDR=GetElementValue(Editors[0].target);
                        rows[i].TimeRange=$(Editors[0].target).combobox('getText');
                        rows[i].Name=GetElementValue(Editors[1].target);
                        if ($(Editors[0].target).combobox('getText')==""){
	                        UnTimeRangeFlag=1
	                    }
	                    if (GetElementValue(Editors[1].target)==""){
	                        UnNameFlag=1
	                    }
	                    rows[i].TempListTypeID=$(Editors[2].target).combobox('getValue');
						if ($(Editors[2].target).combobox('getValue')==""){
		                    $.messager.alert('提示',"模板权限类型不能为空！");
                    		return false;
		                    }
	                    if ((rows[i].TempListTypeID)&&((!$(Editors[3].target).combobox('getValue'))||(rows[i].TempListID==""))) {
		                    $.messager.alert('提示',"模板权限类型不为空时模板权限不能为空！");
                    		return false;
		                }
		                ChangeID=rows[i].ID
                    }else{
	                    if (rows[i].TimeRangeDR==""){
	                        UnTimeRangeFlag=1
	                    }
	                    if (rows[i].Name==""){
	                        UnNameFlag=1
	                    }
	                }
                }
                if (UnTimeRangeFlag==1){
	                $.messager.alert('提示',"时段不能为空");
                    return false;
	            }
	            if (UnNameFlag==1){
	                $.messager.alert('提示',"名称不能为空");
                    return false;
	            }
                var retJson=$.cm({
                    ClassName:'DHCDoc.OPAdm.TimeRangeTemp',
                    MethodName:'Update',
                    InputJson:JSON.stringify(rows),
                    HospID:$HUI.combogrid('#_HospUserList').getValue(),
                    dataType:"json"
                },false);
                if(retJson.Code==0){
                    $.messager.popover({msg:"保存成功!",type:'success'});
                    DeleteDGTBSaveTip('tabTempList');
                    $('#tabTempList').datagrid('reload');
					$('#tabTempList').datagrid('clearSelections');
                    EditRow = undefined;
                    if ((ChangeID=="")) {ChangeID=retJson.ID}
	                setTimeout(function(){ 
						if ((TimeRangChangeFLag==1)&&(ChangeID!="")&&(ChangeID!=undefined)){
	                    var Index=$('#tabTempList').datagrid('getRowIndex',ChangeID);
	                    $('#tabTempList').datagrid('selectRow',Index);
		                SetElementValue("TRASLoad","");
		                SetElementValue("IntervalTime","");
		                $('#TRGenWin').window('open');
		                $('#tabTRAppMethodInfo').datagrid('clearSelections');
		                $('#tabTRClinicGroupInfo').datagrid('clearSelections');
	                    }
					},1000); 
                    return true;
                }else{
                    $.messager.alert('失败',"保存失败:"+retJson.Msg);
                    return false;
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
	            if (EditRow == undefined) { 
	            	return;
	            }
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                EditRow = undefined;
                $('#tabTempList').datagrid("rejectChanges").datagrid("unselectAll");
                DeleteDGTBSaveTip('tabTempList');
            }
        }],
        onBeginEdit:function(index, row){
            var ed = $('#tabTempList').datagrid('getEditor', {index:index,field:'TimeRange'});
            $(ed.target).combobox('setValue', row.TimeRangeDR);
            var ed = $('#tabTempList').datagrid('getEditor', {index:index,field:'TempListType'});
            $(ed.target).combobox('setValue', row.TempListTypeID);
            AddDGTBSaveTip('tabTempList');
            EditRow=index;
        },
        onDblClickRow:function(index,row){
	        if (EditRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			tabtempListType=row.TempListTypeID;
            $(this).datagrid('beginEdit',index);
        },
        onBeforeSelect:function(index,row){
            if(CheckGridEditing('tabTRInfo')){
                return dhcsys_confirm('有未保存的分时段预约方式信息,是否继续?');
            }
            return true;
        },
        onSelect:function(index,row){
            var Data=row.Data;
            if(!Data) Data=[];
            if(typeof(Data)=='string'){
                Data=JSON.parse(Data);
            }
            tabTRInfo=Data;
            var dataObj={
	            "total":Data.length,
	            "rows":Data
	        }
            SetElementValue('tabTRInfo',Data);
        },
        onBeforeLoad:function(param){
	        EditRow = undefined;
            param.ClassName="DHCDoc.OPAdm.TimeRangeTemp";
            param.QueryName="QueryTemp";
            param.TRRowid="";
            param.HospID=$HUI.combogrid('#_HospUserList').getValue();
            param.ArgCnt=2;
        },
        loadFilter: function(data){
            for(var i=0;i<data.rows.length;i++){
                var Data=data.rows[i].Data
                if(!Data) Data=[];
                if(typeof(Data)=='string'){
                    Data=JSON.parse(Data);
                }
                var TotalCount=0;
                for(var j=0;j<Data.length;j++){
                    TotalCount+=Number(Data[j].Load);
                }
                data.rows[i].Load=TotalCount;
            }
            return data;
        },
        onLoadSuccess:function(data){
            $(this).datagrid('unselectAll');
            SetElementValue('tabTRInfo',[]);
            SetElementValue('tabTRAppMethodInfo',[]);
            $('#tabTRAppMethodInfo').datagrid('clearSelections');
        }   
    })//.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
}
function InitTempTRList()
{
    $('#tabTRInfo').datagrid({
	    fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
        url:'',
        columns:[[
            {field:'tabTRAppMethodInfo',hidden:true},
            {field:'tabTRClinicGroupInfo',hidden:true},
            {field:'SttTime',title:'开始时间',align:'center',width:150},
            {field:'EndTime',title:'结束时间',align:'center',width:150},
            {field:'Load',title:'数量',align:'center',width:100,
                editor:{type:'numberbox',options:{min:1}}
            }
        ]],
        toolbar:[{
            text:'重新生成',
            iconCls:'icon-reload',
            handler:function(){
                var TRInfoSelected=$('#tabTempList').datagrid('getSelected');
                if(!TRInfoSelected){
                    $.messager.popover({msg:'请先选择模板！',type:'error'});
                    return;
                }
                SetElementValue("TRASLoad","");
                SetElementValue("IntervalTime","");
                $('#TRGenWin').window('open');
            }
        },'-',{
            text:'保存',
            iconCls:'icon-save',
            handler:function(){
                var TempSelected=$('#tabTempList').datagrid('getSelected');
                if(!TempSelected){
                    $.messager.popover({msg:'请先选择模板！',type:'error'});
                    return;
                }
                var TempIndex=$('#tabTempList').datagrid('getRowIndex',TempSelected);
                var rowsData=$('#tabTRInfo').datagrid('getData');
                var rows=rowsData.originalRows;
                var TotalCount=0
                for(var i=0;i<rowsData.total;i++){
                    var Editors=$('#tabTRInfo').datagrid('getEditors',i);
                    if(Editors.length){
                        rows[i].Load=GetElementValue(Editors[0].target);
                        if ( +rows[i].Load ==0) {
		                     $.messager.popover({msg:'数量不能为空或0！',type:'error'});
                        	  return;
		                }
                    }
                    TotalCount+=Number(rows[i].Load);
                    if (rows[i].tabTRAppMethodInfo){
	                    var ResverNum=0,MaxAppQty=0
	                    for (var j=0;j<rows[i].tabTRAppMethodInfo.length;j++){
		                    var AppMethodID= rows[i].tabTRAppMethodInfo[j].AppMethodID;
		                    if (AppMethodID == "") {
			                    $.messager.popover({msg:'分时段限额中预约方式的不能为空',type:'error'});
	                        	return false;
		                    }
		                    var OneReserveQty= rows[i].tabTRAppMethodInfo[j].ReserveQty;
		                    ResverNum=parseFloat(ResverNum)+parseFloat(OneReserveQty)
		                    var OneMaxQty=rows[i].tabTRAppMethodInfo[j].MaxQty;
		                    MaxAppQty=parseFloat(MaxAppQty)<parseFloat(OneMaxQty)?parseFloat(OneMaxQty):MaxAppQty;
		                }
	                    if (parseFloat(ResverNum)>parseFloat(rows[i].Load)){
		                    $.messager.popover({msg:'分时段限额中预约方式的总保留数应该小于分时段限额',type:'error'});
	                        return;
		                }
		                if (parseFloat(MaxAppQty)>parseFloat(rows[i].Load)){
		                    $.messager.popover({msg:'分时段限额中预约方式的最大预约数应该小于分时段限额',type:'error'});
	                        return;
		                }
                    }
                    if (rows[i].tabTRClinicGroupInfo){
	                    var ClinicNum=0,ClinicArr={};
	                    for (var j=0;j<rows[i].tabTRClinicGroupInfo.length;j++){
		                    var ClinicGroupMethodID= rows[i].tabTRClinicGroupInfo[j].ClinicGroupMethodID;
		                    var ClinicGroup= rows[i].tabTRClinicGroupInfo[j].ClinicGroup;
		                    if (ClinicGroupMethodID == "") {
			                    $.messager.popover({msg:'分时段限额中专业组的不能为空',type:'error'});
	                        	return false;
		                    }
		                    if(ClinicArr.ClinicGroupMethodID) {
			                    $.messager.popover({msg:'分时段限额中 '+ClinicGroup+"方式重复维护!",type:'error'});
	                        	return false;
		                    }
		                    ClinicArr.ClinicGroupMethodID=1;
		                    var OneClinicQty= rows[i].tabTRClinicGroupInfo[j].Qty;
		                    ClinicNum=parseFloat(ClinicNum)+parseFloat(OneClinicQty);
		                }
	                    if (parseFloat(ClinicNum)>parseFloat(rows[i].Load)){
		                    $.messager.popover({msg:'分时段限额中专业组的总数应该小于分时段限额',type:'error'});
	                        return;
		                }
                    }
                }
                
                SetElementValue('tabTRInfo',rows);
                TempSelected.Data=rows;
                TempSelected.Load=TotalCount;
                $('#tabTempList').datagrid('updateRow',{index:TempIndex,row:TempSelected});
                AddDGTBSaveTip('tabTempList');
                DeleteDGTBSaveTip('tabTRInfo');
                $('#tabTRAppMethodInfo').datagrid('clearSelections');
                $('#tabTRClinicGroupInfo').datagrid('clearSelections');
				EditRow = undefined;
            }
        }],
        onDblClickRow:function(index,row){
            $(this).datagrid('beginEdit',index);
        },
        onBeforeSelect:function(index,row){
            if(CheckGridEditing('tabTRAppMethodInfo')){
                var confirmflag=dhcsys_confirm('有未保存的分时段预约方式信息,是否继续?');
                if (confirmflag==true){
                	var CheckFlag=CheckfortabTRAppMethodInfo()
	           		 return CheckFlag;
                }
                return confirmflag
            }
            return true;
        },
        onSelect:function(index,row){
            var tabTRAppMethodInfo=row.tabTRAppMethodInfo;
            if(!tabTRAppMethodInfo) tabTRAppMethodInfo=[];
            if(typeof(tabTRAppMethodInfo)=='string'){
                tabTRAppMethodInfo=JSON.parse(tabTRAppMethodInfo);
            }
            SetElementValue('tabTRAppMethodInfo',tabTRAppMethodInfo);
            $('#tabTRAppMethodInfo').datagrid('clearSelections');
             var tabTRClinicGroupInfo=row.tabTRClinicGroupInfo;
            if(!tabTRClinicGroupInfo) tabTRClinicGroupInfo=[];
            if(typeof(tabTRClinicGroupInfo)=='string'){
                tabTRClinicGroupInfo=JSON.parse(tabTRClinicGroupInfo);
            }
            SetElementValue('tabTRClinicGroupInfo',tabTRClinicGroupInfo);
            $('#tabTRClinicGroupInfo').datagrid('clearSelections');
        },
        onBeforeLoad:function(param){
	        /*var rows=GetElementValue('tabTRInfo');
            for(var i=0;i<rows.length;i++){
                $("#tabTRInfo").datagrid('endEdit',i);
            }*/
            SetElementValue('tabTRInfo',tabTRInfo);
        },
        onLoadSuccess:function(data){
            $(this).datagrid('unselectAll');
            SetElementValue('tabTRAppMethodInfo',[]);
            $('#tabTRAppMethodInfo').datagrid('clearSelections');
            SetElementValue('tabTRClinicGroupInfo',[]);
            $('#tabTRClinicGroupInfo').datagrid('clearSelections');
            DeleteDGTBSaveTip('tabTRInfo');
            var rowsData=$('#tabTRInfo').datagrid('getData');
            var rows=rowsData.originalRows;
            var TotalCount=0;
            for(var i=0;i<rows.length;i++){
                TotalCount+=Number(rows[i].Load);
            }
            $('#pTRInfo').panel('setTitle','模板时段列表(号源合计:'+TotalCount+')');
        },
        onBeginEdit:function(index, row){
            AddDGTBSaveTip('tabTRInfo');
        }
    }).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
}
function InitTempTRAMList()
{
    $('#tabTRAppMethodInfo').datagrid({
	    fit : true,
		border : false,
		striped : true,
		rownumbers:false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		idField:"AppMethodID",
		pageSize: 15,
		pageList : [15,100,200],
        url:'',
        columns:[[
            {field:'AppMethodID',hidden:true},
            {field:'AppMethod',title:'预约方式',align:'center',width:250,
                editor:{
                    type:'combobox',
                    options:{
						valueField:'id',
					    textField:'text', 
					    panelHeight:200, 
					    mode:"local",
					    url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Combo',
                        onBeforeLoad:function(param){
                            param.ClassName='DHCDoc.OPAdm.Schedule';
                            param.QueryName='QueryAppMethod';
                            param.ArgCnt=0;
                        },
                        loadFilter:function(data){
                            var AppMethodArr=new Array();
                            var rows=GetElementValue('tabTRAppMethodInfo');
                            for(var i=0;i<rows.length;i++){
                                var AppMethodID=rows[i].AppMethodID;
                                var ed = $('#tabTRAppMethodInfo').datagrid('getEditor',{index:i,field:'AppMethod'});
                                if(ed) AppMethodID=GetElementValue(ed.target);
                                if(AppMethodID){
                                    AppMethodArr.push(AppMethodID);
                                }
                            }
                            var newData=new Array();
                            for(var i=0;i<data.length;i++){
                                if(AppMethodArr.indexOf(data[i].id)==-1){
                                    newData.push(data[i]);
                                }
                            }
                            return newData;
                        }
                    }
                }
            },
            {field:'MaxQty',title:'最大预约数量',align:'center',width:100,
                editor:{type:'numberbox',options:{min:0}}
            },
            {field:'ReserveQty',title:'保留数量',align:'center',width:100,
                editor:{type:'numberbox',options:{min:0}}
            }
        ]],
        toolbar:[{
            text:'增加',
            iconCls:'icon-add',
            handler:function(){
                var TRInfoSelected=$('#tabTRInfo').datagrid('getSelected');
                if(!TRInfoSelected){
                    $.messager.popover({msg:'请先选时段！',type:'error'});
                    return;
                }
                $('#tabTRAppMethodInfo').datagrid('appendRow',{});
                var rows=$('#tabTRAppMethodInfo').datagrid('getRows');
                $('#tabTRAppMethodInfo').datagrid('beginEdit',rows.length-1);
            }
        },{
            text:'删除',
            iconCls:'icon-remove',
            handler:function(){
                var Selected=$('#tabTRAppMethodInfo').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"请选择需要删除的行!",type:'alert'});
                    return;
                }
                $.messager.confirm('提示','确定删除此条数据?',function(r){
                    if(r){
                        var index=$('#tabTRAppMethodInfo').datagrid('getRowIndex',Selected);
                        $('#tabTRAppMethodInfo').datagrid('deleteRow',index);
                        AddDGTBSaveTip('tabTRAppMethodInfo');
                    }
                });
            }
        },{
            text:'保存',
            iconCls:'icon-save',
            handler:function(){
	            var CheckFlag=CheckfortabTRAppMethodInfo()
	            if (CheckFlag==false) return;
                var TRInfoSelected=$('#tabTRInfo').datagrid('getSelected');
                var TRInfoIndex=$('#tabTRInfo').datagrid('getRowIndex',TRInfoSelected);
                var TRLoad=TRInfoSelected.Load;
                var ed = $('#tabTRInfo').datagrid('getEditor', {index:TRInfoIndex,field:'Load'});
                if(ed) TRLoad=GetElementValue(ed.target);
                var newRows=new Array();
                var AMArr=new Array();
                var ReserveQtySum=0;
                var rows=$('#tabTRAppMethodInfo').datagrid('getRows');
                for(var i=0;i<rows.length;i++){
                    var Editors=$('#tabTRAppMethodInfo').datagrid('getEditors',i);
                    if(Editors.length){
                        rows[i].AppMethodID=GetElementValue(Editors[0].target);
                        rows[i].AppMethod=$(Editors[0].target).combobox('getText');
                        rows[i].MaxQty=GetElementValue(Editors[1].target);
                        rows[i].ReserveQty=GetElementValue(Editors[2].target);
                        $('#tabTRAppMethodInfo').datagrid('updateRow',{index:i,row:rows[i]});
                        $('#tabTRAppMethodInfo').datagrid('endEdit',i);
                    }
                    if(rows[i].AppMethodID){
                        ReserveQtySum+=parseInt(rows[i].ReserveQty);
                        newRows.push(rows[i]);
                        AMArr[rows[i].AppMethodID]=1
                    }
                }
                SetElementValue('tabTRAppMethodInfo',newRows);
                $('#tabTRAppMethodInfo').datagrid('unselectAll');
                TRInfoSelected.tabTRAppMethodInfo=newRows;
                var Editors=$('#tabTRInfo').datagrid('getEditors',TRInfoIndex);
                if(Editors.length){
                    TRInfoSelected.Load=GetElementValue(Editors[0].target);
                }
                $('#tabTRInfo').datagrid('updateRow',{index:TRInfoIndex,row:TRInfoSelected});
                AddDGTBSaveTip('tabTRInfo');
            }
        }],
        onDblClickRow:function(index,row){
            $(this).datagrid('beginEdit',index);
        },
        onLoadSuccess:function(data){
            $(this).datagrid('unselectAll');
            DeleteDGTBSaveTip('tabTRAppMethodInfo');
        },
        onBeginEdit:function(index, row){
            var ed = $(this).datagrid('getEditor', {index:index,field:'AppMethod'});
            SetElementValue(ed.target,row.AppMethodID);
            AddDGTBSaveTip('tabTRAppMethodInfo');
        }
    }).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
    $('#tabTRClinicGroupInfo').datagrid({
	    fit : true,
		border : false,
		striped : true,
		rownumbers:false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		idField:"ClinicGroupMethodID",
		pageSize: 15,
		pageList : [15,100,200],
        url:'',
        columns:[[
            {field:'ClinicGroupMethodID',hidden:true},
            {field:'ClinicGroup',title:'专业组',align:'center',width:250,
                editor:{
                    type:'combobox',
                    options:{
						valueField:'CGRowid',
					    textField:'CGDesc', 
					    panelHeight:200, 
					    mode:"local",
					    url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Combo',
                        onBeforeLoad:function(param){
                            param.ClassName='DHCDoc.OPAdm.Schedule';
                            param.QueryName='QueryClinicGroupNew';
                            param.HospID=$HUI.combogrid('#_HospUserList').getValue();
                            param.ArgCnt=1;
                        },
                        loadFilter:function(data){
                            var AppMethodArr=new Array();
                            var rows=GetElementValue('tabTRClinicGroupInfo');
                            for(var i=0;i<rows.length;i++){
                                var ClinicGroupMethodID=rows[i].ClinicGroupMethodID;
                                var ed = $('#tabTRClinicGroupInfo').datagrid('getEditor',{index:i,field:'ClinicGroup'});
                                if(ed) ClinicGroupMethodID=GetElementValue(ed.target);
                                if(ClinicGroupMethodID){
                                    AppMethodArr.push(ClinicGroupMethodID);
                                }
                            }
                            var newData=new Array();
                            for(var i=0;i<data.length;i++){
                                if(AppMethodArr.indexOf(data[i].id)==-1){
                                    newData.push(data[i]);
                                }
                            }
                            return newData;
                        }
                    }
                }
            },
            {field:'Qty',title:'数量',align:'center',width:100,
                editor:{type:'numberbox',options:{min:0}}
            }
        ]],
        toolbar:[{
            text:'增加',
            iconCls:'icon-add',
            handler:function(){
                var TRInfoSelected=$('#tabTRInfo').datagrid('getSelected');
                if(!TRInfoSelected){
                    $.messager.popover({msg:'请先选时段！',type:'error'});
                    return;
                }
                $('#tabTRClinicGroupInfo').datagrid('appendRow',{});
                var rows=$('#tabTRClinicGroupInfo').datagrid('getRows');
                $('#tabTRClinicGroupInfo').datagrid('beginEdit',rows.length-1);
            }
        },{
            text:'删除',
            iconCls:'icon-remove',
            handler:function(){
                var Selected=$('#tabTRClinicGroupInfo').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"请选择需要删除的行!",type:'alert'});
                    return;
                }
                $.messager.confirm('提示','确定删除此条数据?',function(r){
                    if(r){
                        var index=$('#tabTRClinicGroupInfo').datagrid('getRowIndex',Selected);
                        $('#tabTRClinicGroupInfo').datagrid('deleteRow',index);
                        AddDGTBSaveTip('tabTRClinicGroupInfo');
                    }
                });
            }
        },{
            text:'保存',
            iconCls:'icon-save',
            handler:function(){
	            var CheckFlag=CheckfortabTRClinicGroupInfo()
	            if (CheckFlag==false) return;
                var TRInfoSelected=$('#tabTRInfo').datagrid('getSelected');
                var TRInfoIndex=$('#tabTRInfo').datagrid('getRowIndex',TRInfoSelected);
                var TRLoad=TRInfoSelected.Load;
                var ed = $('#tabTRInfo').datagrid('getEditor', {index:TRInfoIndex,field:'Load'});
                if(ed) TRLoad=GetElementValue(ed.target);
                var newRows=new Array();
                var AMArr=new Array();
                var ReserveQtySum=0;
                var rows=$('#tabTRClinicGroupInfo').datagrid('getRows');
                for(var i=0;i<rows.length;i++){
                    var Editors=$('#tabTRClinicGroupInfo').datagrid('getEditors',i);
                    if(Editors.length){
                        rows[i].ClinicGroupMethodID=GetElementValue(Editors[0].target);
                        rows[i].ClinicGroup=$(Editors[0].target).combobox('getText');
                        rows[i].Qty=GetElementValue(Editors[1].target);
                        $('#tabTRClinicGroupInfo').datagrid('updateRow',{index:i,row:rows[i]});
                        $('#tabTRClinicGroupInfo').datagrid('endEdit',i);
                    }
                    if(rows[i].ClinicGroupMethodID){
                        ReserveQtySum+=parseInt(rows[i].Qty);
                        newRows.push(rows[i]);
                        AMArr[rows[i].AppMethodID]=1
                    }
                }
                SetElementValue('tabTRClinicGroupInfo',newRows);
                $('#tabTRClinicGroupInfo').datagrid('unselectAll');
                TRInfoSelected.tabTRClinicGroupInfo=newRows;
                /*var Editors=$('#tabTRInfo').datagrid('getEditors',TRInfoIndex);
                if(Editors.length){
                    TRInfoSelected.Load=GetElementValue(Editors[0].target);
                }*/
                $('#tabTRInfo').datagrid('updateRow',{index:TRInfoIndex,row:TRInfoSelected});
                AddDGTBSaveTip('tabTRInfo');
            }
        }],
        onDblClickRow:function(index,row){
            $(this).datagrid('beginEdit',index);
        },
        onLoadSuccess:function(data){
            $(this).datagrid('unselectAll');
            DeleteDGTBSaveTip('tabTRClinicGroupInfo');
        },
        onBeginEdit:function(index, row){
            var ed = $(this).datagrid('getEditor', {index:index,field:'ClinicGroup'});
            SetElementValue(ed.target,row.ClinicGroupMethodID);
            AddDGTBSaveTip('tabTRClinicGroupInfo');
        }
    }).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
}
function CheckfortabTRClinicGroupInfo(){
	
	var TRInfoSelected=$('#tabTRInfo').datagrid('getSelected');
    if(!TRInfoSelected){
        $.messager.popover({msg:'请选择时段后再维护时段预约方式',type:'error'});
        return false;
    }
    var TRInfoIndex=$('#tabTRInfo').datagrid('getRowIndex',TRInfoSelected);
    var TRLoad=TRInfoSelected.Load;
    var ed = $('#tabTRInfo').datagrid('getEditor', {index:TRInfoIndex,field:'Load'});
    if(ed) TRLoad=GetElementValue(ed.target);
    var newRows=new Array();
    var AMArr=new Array();
    var ReserveQtySum=0;
    var rows=$('#tabTRClinicGroupInfo').datagrid('getRows');
    for(var i=0;i<rows.length;i++){
        var Editors=$('#tabTRClinicGroupInfo').datagrid('getEditors',i);
        if(Editors.length){
            rows[i].ClinicGroupMethodID=GetElementValue(Editors[0].target);
            rows[i].ClinicGroup=$(Editors[0].target).combobox('getText');
            rows[i].Qty=GetElementValue(Editors[1].target);
        }
        if(rows[i].ClinicGroupMethodID){
            if(AMArr[rows[i].ClinicGroupMethodID]){
                $.messager.popover({msg:rows[i].ClinicGroup+"方式重复维护!",type:'error'});
                return false;
            }
            if(rows[i].Qty==""){
                $.messager.popover({msg:"亚专业数量不能为空!",type:'error'});
                return false;
            }
            ReserveQtySum+=parseInt(rows[i].Qty);
            newRows.push(rows[i]);
            AMArr[rows[i].ClinicGroupMethodID]=1
        }
    }
    if(ReserveQtySum>parseInt(TRLoad)){
        $.messager.popover({msg:"亚专业数量合计:"+ReserveQtySum+",不能超过时段总数:"+TRLoad+"!",type:'error'});
        return false;
    }
    return true;
}
function CheckfortabTRAppMethodInfo(){
	
	var TRInfoSelected=$('#tabTRInfo').datagrid('getSelected');
    if(!TRInfoSelected){
        $.messager.popover({msg:'请选择时段后再维护时段预约方式',type:'error'});
        return false;
    }
    var TRInfoIndex=$('#tabTRInfo').datagrid('getRowIndex',TRInfoSelected);
    var TRLoad=TRInfoSelected.Load;
    var ed = $('#tabTRInfo').datagrid('getEditor', {index:TRInfoIndex,field:'Load'});
    if(ed) TRLoad=GetElementValue(ed.target);
    var newRows=new Array();
    var AMArr=new Array();
    var ReserveQtySum=0;
    var rows=$('#tabTRAppMethodInfo').datagrid('getRows');
    for(var i=0;i<rows.length;i++){
        var Editors=$('#tabTRAppMethodInfo').datagrid('getEditors',i);
        if(Editors.length){
            rows[i].AppMethodID=GetElementValue(Editors[0].target);
            rows[i].AppMethod=$(Editors[0].target).combobox('getText');
            rows[i].MaxQty=GetElementValue(Editors[1].target);
            rows[i].ReserveQty=GetElementValue(Editors[2].target);
        }
        if(rows[i].AppMethodID){
            if(AMArr[rows[i].AppMethodID]){
                $.messager.popover({msg:rows[i].AppMethod+"方式重复维护!",type:'error'});
                return false;
            }
            /*if(rows[i].ReserveQty==""){
                $.messager.popover({msg:"保留数量不能为空!",type:'error'});
                return false;
            }*/
            if(rows[i].MaxQty==""){
                $.messager.popover({msg:"最大预约数量不能为空!",type:'error'});
                return false;
            }
            if(parseInt(rows[i].ReserveQty)>parseInt(rows[i].MaxQty)){
                $.messager.popover({msg:rows[i].AppMethod+"方式保留数量不能大于最大预约数量!",type:'error'});
                return false;
            }
            if(parseInt(rows[i].MaxQty)>parseInt(TRLoad)){
                $.messager.popover({msg:rows[i].AppMethod+"方式最大预约数量不能超过时段总数:"+TRLoad+"!",type:'error'});
                return false;
            }
            ReserveQtySum+=parseInt(rows[i].ReserveQty);
            newRows.push(rows[i]);
            AMArr[rows[i].AppMethodID]=1
        }
    }
    if(ReserveQtySum>parseInt(TRLoad)){
        $.messager.popover({msg:"保留数量合计:"+ReserveQtySum+",不能超过时段总数:"+TRLoad+"!",type:'error'});
        return false;
    }
    return true;
}
function TRGenClick()
{
    var SttTime=GetElementValue('SttTime');
    var EndTime=GetElementValue('EndTime');
    var IntervalTime=GetElementValue('IntervalTime');
    var ASLoad=GetElementValue('TRASLoad');
    if(CalculateTRInfo(SttTime,EndTime,IntervalTime,ASLoad)){
        AddDGTBSaveTip('tabTRInfo');
        $('#TRGenWin').window('close');
    }
}
function CalculateTRInfo(SttTime,EndTime,IntervalTime,ASLoad)
{
    if((IntervalTime=="")||(SttTime=="")||(EndTime=="")||(ASLoad=="")) return false;
    var SttMin=TimeToMin(SttTime);
    var EndMin=TimeToMin(EndTime);
    var IntervalTime=Number(IntervalTime);
    var ASLoad=Number(ASLoad);
    var TRLength=EndMin-SttMin;
    if(TRLength%IntervalTime){
        $.messager.popover({msg:"分时段间隔时间不能均分时段!",type:'error'});
        $('#IntervalTime').select();
        return false;
    }
    var DataArr=new Array();
    var TRCount=TRLength/IntervalTime;
    for(var i=1;i<=TRCount;i++){
        var SttTime=SttMin+(i-1)*IntervalTime;
        var EndTime=SttMin+i*IntervalTime;
        var Load=Math.floor(ASLoad/(TRCount-i+1));
        ASLoad-=Load;
        var obj={SttTime:MinToTime(SttTime),EndTime:MinToTime(EndTime),Load:Load};
        DataArr.push(obj);
    }
    tabTRInfo=DataArr;
    SetElementValue('tabTRInfo',DataArr);
    return true;
    function TimeToMin(TimStr)
    {
        return Number(TimStr.split(':')[0])*60+Number(TimStr.split(':')[1]);
    }
    function MinToTime(Mins)
    {
        var hour=Math.floor(Mins/60);
        if(hour<10) hour='0'+hour;
        var min=(Mins%60);
        if(min<10) min='0'+min;
        return hour+":"+min;
    }
}
function InitTRWin()
{
    $('#TRGenWin').window({
        onBeforeOpen:function(){
            var Selected=$('#tabTempList').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"请先选择模板!",type:'alert'});
                return false;
            }
            SetElementValue('SttTime',Selected.SttTime);
            SetElementValue('EndTime',Selected.EndTime);
            return true;
        }
    });
}
