//名称    dhcpe/ct/dhcpeexpertdiagnosis.js
//功能    专家建议-多院区    
//创建    2019.04.26
//创建人  yupeng

var UserId=session['LOGON.USERID']
var editIndex=undefined;
var RelateditIndex=undefined;
var ConditioneditIndex=undefined;
var PCeditIndex=undefined;

var tableName = "DHC_PE_ExpertDiagnosis";
var tableNameIDR="DHC_PE_IDRelate"
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']


function PCClickRow(index){
        if (PCeditIndex!=index) {
            if (PCendEditing()){
                $('#PCExpertDiagnosisGrid').datagrid('selectRow',index).datagrid('beginEdit',index);
                PCeditIndex = index;
            } else {
                $('#PCExpertDiagnosisGrid').datagrid('selectRow',PCeditIndex);
            }
        }
}
function PCendEditing(){
            if (PCeditIndex == undefined){return true}
            if ($('#PCExpertDiagnosisGrid').datagrid('validateRow', PCeditIndex)){
                
                $('#PCExpertDiagnosisGrid').datagrid('endEdit', PCeditIndex);
                
                PCeditIndex = undefined;
                return true;
            } else {
                return false;
            }
}

function endEditing(){
            if (editIndex == undefined){return true}
            if ($('#DHCPEEDAlias').datagrid('validateRow', editIndex)){
                
                $('#DHCPEEDAlias').datagrid('endEdit', editIndex);
                
                editIndex = undefined;
                return true;
            } else {
                return false;
            }
}
function RelatedendEditing(){
            if (RelateditIndex == undefined){return true}
            if ($('#DHCPEIDRelate').datagrid('validateRow', RelateditIndex)){
                
                $('#DHCPEIDRelate').datagrid('endEdit', RelateditIndex);
                
                RelateditIndex = undefined;
                return true;
            } else {
                return false;
            }
}

function ConditionendEditing(){
            if (ConditioneditIndex == undefined){return true}
            if ($('#DHCPEEDCondition').datagrid('validateRow', ConditioneditIndex)){
                
                var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TItemID'});
                var name = $(ed.target).combobox('getText');
                $('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TItem'] = name;
                
                
                var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TOperator'});
                var name = $(ed.target).combobox('getText');
                $('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TOperatorname'] = name;
                
                
                var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TSex'});
                var name = $(ed.target).combobox('getText');
                $('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TSexname'] = name;
                
                
                
                $('#DHCPEEDCondition').datagrid('endEdit', ConditioneditIndex);
                
                ConditioneditIndex = undefined;
                return true;
            } else {
                return false;
            }
}


function AliasClickRow(index){
        if (editIndex!=index) {
            if (endEditing()){
                $('#DHCPEEDAlias').datagrid('selectRow',index).datagrid('beginEdit',index);
                editIndex = index;
            } else {
                $('#DHCPEEDAlias').datagrid('selectRow',editIndex);
            }
        }
}

function RelateClickRow(index){
        if (RelateditIndex!=index) {
            if (RelatedendEditing()){
                $('#DHCPEIDRelate').datagrid('selectRow',index).datagrid('beginEdit',index);
                RelateditIndex = index;
            } else {
                $('#DHCPEIDRelate').datagrid('selectRow',RelateditIndex);
            }
        }
}

function ConditionClickRow(index){
        
        if (ConditioneditIndex!=index) {
            if (ConditionendEditing()){
                
                
                $('#DHCPEEDCondition').datagrid('selectRow',index).datagrid('beginEdit',index);
                ConditioneditIndex = index;
                
                
                
            } else {
                $('#DHCPEEDCondition').datagrid('selectRow',ConditioneditIndex);
            }
        }
}

$(function(){
    
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	

    //获取下拉列表
    GetLocComp(SessionStr)
    
    
    InitCombobox();
    
    //保存（专家建议弹窗）
    $("#NSave").click(function() {  
        NSave_click();      
    });
     
    //保存（表达式）   
    $("#BSave").click(function() {  
        BSave_click();      
    });
    
    //查询  
    $("#Find").click(function() {   
        Find_click();       
    });
	
    //知识库同步
    $("#KBSynchro").click(function() {   
        KBSynchro_click();
    });
	
    //科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
	  		LocList_Change();
	  	
  		}
	})
    

	//初始化建议表达式界面
    InitEDConditionGrid();

   
    //初始化疾病与建议对照界面
    InitIDRelateGrid();   
    
    //初始化排斥建议界面
    InitPCExpertDiagnosisGrid();     

  	//初始化建议别名维护
  	InitEDAliasGrid();    
   
    //初始化专家建议Grid
	InitExpertDiagnosisGrid();  
	
	  //默认"激活"勾选
    $("#ActiveFlag").checkbox('setValue',true); 
})

//知识库同步
function KBSynchro_click()
{
    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var UserID = session["LOGON.USERID"];
	var ret=tkMakeServerCall("web.DHCPE.KBA.SynchroService","SynchroDiagnosAndDisease",LocID,UserID);
	if(parseInt(ret)<1){
        $.messager.alert("提示","同步知识库（专家建议&疾病）错误!","info");
    } else {
		$.messager.alert("提示","同步知识库（专家建议&疾病）成功!","info");
	}
	$("#KBSynchro").hide();
}

//新增（专家建议）
var addExpertDiagnosis = function(){
    
    $HUI.window("#ExpertDiagnosis",{
        title:"维护专家建议",
        iconCls:'icon-w-add',
        collapsible:false,
        minimizable:false,
        modal:true
    });
    
    $("#ExpertDiagnosisGrid").datagrid('clearSelections'); //取消选中状态

    var ret=tkMakeServerCall("web.DHCPE.CT.ExpertDiagnosis","InitED","","")
    
    var EDList=ret.split("^");
    setValueById("NCode",EDList[5]);
    setValueById("ParrefRowId","");
    setValueById("NStationID","");
    setValueById("NDiagnoseConclusion","");
    setValueById("NSort","");
    setValueById("EDCRID","");
    setValueById("NStationLoc","");
    setValueById("NDetail","");
    setValueById("NDiagnosisLevel","");
    setValueById("NSex","");
    setValueById("NAlias","");
    $('#NAlias').attr("disabled",false);
    $("#NHighRisk").checkbox('setValue',false);
    $("#NActiveFlag").checkbox('setValue',false);
    $("#NYGFlag").checkbox('setValue',false);
    $("#Empower").checkbox('setValue',false);
    
    //$("#ExpertDiagnosis").datagrid('clearSelections'); //取消选中状态
}

//修改（专家建议）
var updateExpertDiagnosis = function(){
    
    
    var ParrefRowId=getValueById("ParrefRowId")
    
    if(ParrefRowId=="") 
    {
        $.messager.alert("提示","请选择需要修改的记录!","info");
        return
    }
    
    $HUI.window("#ExpertDiagnosis",{
        title:"维护专家建议",
        iconCls:'icon-w-edit',
        collapsible:false,
        minimizable:false,
        modal:true
    });
    
    
    var ret=tkMakeServerCall("web.DHCPE.CT.ExpertDiagnosis","InitED",ParrefRowId,session['LOGON.CTLOCID'])
    //alert(ret)
    var EDList=ret.split("^");
    setValueById("NCode",EDList[5]);
    setValueById("NDiagnoseConclusion",EDList[0]); //结论
    setValueById("NStationID",EDList[6]);
    setValueById("NAlias","");
    $('#NAlias').attr("disabled",true);
    
    if(EDList[7]=="Y") $("#NHighRisk").checkbox('setValue',true);
    else $("#NHighRisk").checkbox('setValue',false);
    setValueById("NSort",EDList[8]);
    setValueById("EDCRID",EDList[18]);
    
    setValueById("NStationLocID",EDList[9]);
    //$("#NStationLoc").combogrid('setValue',EDList[18]);
    $('#NStationLoc').combogrid('grid').datagrid('reload',{'q':EDList[19]});
    $("#NStationLoc").combogrid('setValue',EDList[9]);

    setValueById("NDetail",EDList[15]); //建议

    setValueById("NDiagnosisLevel",EDList[17]);
    
    setValueById("NSex",EDList[10]);
    
    if(EDList[12]=="Y") $("#NActiveFlag").checkbox('setValue',true);
    else $("#NActiveFlag").checkbox('setValue',false);
    
    if(EDList[11]=="Y") $("#NYGFlag").checkbox('setValue',true);
    else $("#NYGFlag").checkbox('setValue',false);
    
    if(EDList[20]=="Y") $("#Empower").checkbox('setValue',true);
    else $("#Empower").checkbox('setValue',false);
    
}


var PCExpertDiagnosis = function(){
    
    
    var ParrefRowId=getValueById("ParrefRowId")
    
    if(ParrefRowId=="") 
    {
        $.messager.alert("提示","请选择需要修改的记录!","info");
        return
    }
    
    $HUI.window("#PCExpertDiagnosis",{
        title:"排斥建议维护",
        collapsible:false,
        minimizable:false,
        iconCls:'icon-w-paper',
        modal:true
    });
    
    $("#PCExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.EDBlackBall",QueryName:"QueryAll",Parref:ParrefRowId}); 
    PCeditIndex=undefined;
}

//保存（建议表达式）
function BSave_click()
{
    ConditionendEditing();
    var Char_1=String.fromCharCode(1);
    var Express=""
    var rows = $("#DHCPEEDCondition").datagrid("getRows"); 
    
    for(var i=0;i<rows.length;i++){
        
        var OneRowInfo="",Select="N",PreBracket="",ItemID="",Operator="",ODStandardID="",Reference="",AfterBracket="",Relation="",Sex="N";
        var EKBXCode="",EKBItemDtlCode="",EKBItemDtlDesc="";

        ItemID=rows[i].TItemID;
        //if (ItemID=="") break;

        PreBracket=rows[i].TPreBracket;
        AfterBracket=rows[i].TAfterBracket;
        Relation=rows[i].TRelation;
        Operator=rows[i].TOperator;
        
        
        Reference=rows[i].TReference;
        Sex=rows[i].TSex;
        NoBloodFlag=rows[i].TNoBloodFlag;
        
        ODStandardID=""
        AgeRange=rows[i].TAgeRange;
        
        if(AgeRange!="") {
            if(AgeRange.indexOf("-")==-1)
            {
                $.messager.alert("提示","输入年龄范围格式不正确,应为10-20!","info");
                return false;
            }
            var AgeMin=AgeRange.split("-")[0];
            var AgeMax=AgeRange.split("-")[1];
            if((isNaN(AgeMin))||(isNaN(AgeMax)))
            {
                $.messager.alert("提示","输入年龄不是数字!","info");
                return false;
        
            }
            
        }

		var EKBXCode=rows[i].EKBXCode;            //知识库专家建议表达式（外部码）
        var EKBItemDtlCode=rows[i].EKBItemDtlCode; //知识库站点细项代码
        var EKBItemDtlDesc=rows[i].EKBItemDtlDesc; //知识库站点细项名称
		
		if ((ItemID=="")&&(EKBItemDtlCode==""))  break;
        OneRowInfo=PreBracket+"^"+ItemID+"^"+Operator+"^"+ODStandardID+"^"+Reference+"^"+Sex+"^"+AfterBracket+"^"+Relation+"^"+NoBloodFlag+"^"+AgeRange+"^"+EKBXCode+"^"+EKBItemDtlCode+"^"+EKBItemDtlDesc;
        
        if (Express!=""){
            Express=Express+Char_1+OneRowInfo;
        }else{
            Express=OneRowInfo;
        }
        

    }
    
    var iType="ED";
    var ParrefRowId=getValueById("ParrefRowId")
    if (Express!=""){
		var ret=tkMakeServerCall("web.DHCPE.ExcuteExpress","SaveNewExpress",iType,ParrefRowId,Express);
	}
        
    if (ret==0){
            
        $("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:ParrefRowId,Type:""}); 
        ConditioneditIndex = undefined;
        return true;    
    }
    
    
}



function NSave_click() {
    var DiagnoseConclusion=getValueById("NDiagnoseConclusion");
    if (""==DiagnoseConclusion){
        $.messager.alert("提示","请填写结论!","info");
        return false
    } 
    
    var EDRowId=getValueById("ParrefRowId");
    
    
    
    
    var EDAlias=getValueById("NAlias");
    
    if ((""==EDAlias)&&(EDRowId=="")) {
        $.messager.alert("提示","必须填写别名!","info");
        return false
    }
    
    var StationID=getValueById("NStationID");
    if (""==StationID){
        $.messager.alert("提示","必须选择站点!","info");
        return false;
    }
    
    var Detail="";
    var obj=document.getElementById("NDetail");
    if (obj) { Detail=obj.value; }
    if (""==Detail) {
        $.messager.alert("提示","请填写建议!","info");
        return false;
    }
    
    var RelateFlag="N";
    var obj=document.getElementById("GetRelateFlag");
    if (obj) { RelateFlag=obj.value; }
    
    var IllRowID="";
    var obj=document.getElementById("IllRowID");
    if (obj) { IllRowID=obj.value; }
    
    if ((RelateFlag=="Y")&&(IllRowID=="")) {
        $.messager.alert("提示","必须关联疾病!","info");
        return false
    }
    
    var Code=getValueById("NCode");
    
    var Illness="N", CommonIllness="N", Active="N";
    
    var obj=$("#NActiveFlag").checkbox('getValue');
    if (obj) Active="Y";
    
    var LevelID=getValueById("NDiagnosisLevel");
    
    var InsertType="";
    var obj=document.getElementById("InsertType");
    if (obj) { InsertType=obj.value; }
    
    var HighRisk="N";
    var obj=$("#NHighRisk").checkbox('getValue');
    if (obj) HighRisk="Y";
    
    var YGFlag="N";
    var obj=$("#NYGFlag").checkbox('getValue');
    if (obj) YGFlag="Y";
      
    var Sort=$("#NSort").val();
        
    var StationLocID=$("#NStationLoc").combogrid('getValue');
    if (($('#NStationLoc').combogrid('getValue')==undefined)||($('#NStationLoc').combogrid('getValue')=="")) { StationLocID=""; }
    //if (StationLocID.split("||").length < 2) { StationLocID=$("#NStationLocID").val(); }

        
    var SexDR=$("#NSex").combobox('getValue');
    if (($('#NSex').combobox('getValue')==undefined)||($('#NSex').combobox('getValue')=="")){var SexDR="";}
        

    var InString=Code+"^"+DiagnoseConclusion+"^"+Detail+"^"+Illness+"^"+CommonIllness+"^"+UserId+"^"+InsertType+"^"+EDAlias+"^"+StationID+"^"+Active+"^"+LevelID+"^"+IllRowID+"^"+HighRisk+"^"+Sort+"^"+StationLocID+"^"+SexDR+"^"+YGFlag;
        
    var EDCRID=getValueById("EDCRID");
    
    var EmpowerFlag=$("#Empower").checkbox('getValue') ? "Y" : "N";
    var ExpStr=HighRisk+"^"+Sort+"^"+StationLocID+"^"+YGFlag+"^"+$("#LocList").combobox('getValue')+"^"+EDAlias+"^"+EmpowerFlag;
    
    var value=tkMakeServerCall("web.DHCPE.CT.ExpertDiagnosis","UpdateED",EDRowId,Code,DiagnoseConclusion,Detail,Illness,CommonIllness,UserId,StationID,Active,LevelID,EDCRID,SexDR,ExpStr);
    
    values=value.split("^");
    flag=values[0];
    if ('0'==flag) {
        if (InsertType!="User") {  
            $.messager.alert("提示","操作成功!","info");
            $('#ExpertDiagnosis').window('close'); 
            $("#ExpertDiagnosisGrid").datagrid('reload');
        }
    } else {
        $.messager.alert("提示","Update error.ErrNo="+flag,"info");
    }   
}

//数据关联科室
function BRelateLoc_click()
{
	
    var DataID=$("#ParrefRowId").val()
    if (DataID==""){
        $.messager.alert("提示","请选择需要授权的记录","info"); 
        return false;
    }
   
   var LocID=$("#LocList").combobox('getValue')
   
   OpenLocWin(tableName,DataID,SessionStr,LocID,InitExpertDiagnosisGrid)
    
}

function Find_click()
{
    
    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
    var HighRisk="";
    var obj=$("#HighRisk").checkbox('getValue');
    if (obj) HighRisk="Y";
    var ActiveFlag="N";
    var obj=$("#ActiveFlag").checkbox('getValue');
    if (obj) ActiveFlag="Y";

    $("#ExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.CT.ExpertDiagnosis",QueryName:"QueryED",Code:getValueById("Code"),
            DiagnoseConclusion:getValueById("DiagnoseConclusion"),
            Alias:getValueById("Alias"),
            StationID:$("#StationID").combobox("getValue"),
            ChartID:"",
            HighRisk:HighRisk,
            ActiveFlag:ActiveFlag,
            StationName:"",
            tableName:tableName, 
            LocID:LocID
            
            }); 
    
}

function InitCombobox(){

      var LocID=session['LOGON.CTLOCID']
	  var LocListID=$("#LocList").combobox('getValue');
	  if(LocListID!=""){var LocID=LocListID; }
	  var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	  
	  
	  
    //级别
    var NDiagnosisLevelObj = $HUI.combobox("#NDiagnosisLevel",{
       url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=DiagnosisLevel&ResultSetType=array&LocID="+LocID,
        valueField:'id',
        textField:'desc'
    })
      
    //性别  
    var NSexObj = $HUI.combobox("#NSex",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
        valueField:'id',
        textField:'sex'
    })
     
     //站点  
    var StationIDObj = $HUI.combobox("#StationID",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID,
        valueField:'id',
        textField:'desc'
    });
    
    //站点 (弹窗)   
    var NStationIDObj = $HUI.combobox("#NStationID",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID,
        valueField:'id',
        textField:'desc'
    });
    
   
    //分组名称
    var NStationLocObj = $HUI.combogrid("#NStationLoc",{
       //panelWidth:300,
        url:$URL+"?ClassName=web.DHCPE.CT.StationLoc&QueryName=FindStationLoc",
        mode:'remote',
        delay:200,
        idField:'TSLID',
        textField:'TSLDesc',
        onBeforeLoad:function(param){
            
            var STId=$("#NStationID").combobox("getValue");
            param.StationID = STId;
            param.LocID = LocID;
            param.Desc= param.q;
        },
        onShowPanel:function()
        {
            $('#NStationLoc').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'TSLID',hidden:true},
            {field:'TSLDesc',title:'分组名称',width:140}
        ]]
    });
    
        
        
    
}

//初始化建议表达式界面
function InitEDConditionGrid(){
 
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	//var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

    $HUI.datagrid("#DHCPEEDCondition",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        singleSelect: true,
        selectOnCheck: false,
        onClickRow: ConditionClickRow,
        queryParams:{
            ClassName:"web.DHCPE.ExcuteExpress",
            QueryName:"FindExpress",
            ParrefRowId:"",
            Type:""
        },
        columns:[[
            {
	          field:'TPreBracket',
	          title:'前置括号',
              editor:{
                    type:'combobox',
                    options:{
                        valueField:'id',
                        textField:'text',
                        data:[
                            {id:'(',text:'('},{id:'((',text:'(('},{id:'(((',text:'((('},{id:'((((',text:'(((('},{id:'(((((',text:'((((('}
                        ]
                        
                    }
                }
            },  
            {
	            field:'TItemID',
	            title:'项目',
	            width:130,
            	formatter:function(value,row){
                        return row.TItem;
                    },
                    
                editor:{
                    type:'combobox',
                    options:{
                        valueField:'TODID',
                        textField:'TODDescNew',
                        //method:'get',
                        //mode:'remote',
                       url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindOrderDetail&ResultSetType=array&LocID="+LocID,
                        onBeforeLoad:function(param){
                            param.Desc = param.q;
                            
                            },
                       onSelect: function (rowData) {
	                           
								var String="^"+rowData.TODCode+"^"+rowData.TODID;
								var NorInfo=tkMakeServerCall("web.DHCPE.ODStandard","GetNorInfo",String);
								//alert("NorInfo:"+NorInfo)
								$("#NorInfo").val(NorInfo)
							
						},
                        
                    }
                }       
                    
           
            },
			{field:' EKBXCode',title:' EKBXCode',hidden: true},
			{field:'EKBItemDtlCode',title:'知识库细项代码',width:130},
            {field:'EKBItemDtlDesc',title:'知识库细项名称',width:130},
            {
	          field:'TOperator',
	          title:'运算符',
	          width:70, 
              formatter:function(value,row){
                        return row.TOperatorname;
                    },
              editor:{
                    type:'combobox',
                    options:{
                        valueField:'id',
                        textField:'text',
                        data:[
                            {id:'>',text:'大于'},{id:'>=',text:'大于等于'},{id:'<',text:'小于'},{id:'<=',text:'小于等于'},{id:'[',text:'包含'},{id:"'[",text:'不包含'},{id:'=',text:'等于'},{id:"'=",text:'不等于'}
                        ]
                        
                    }
                }
            },
            {
	          field:'TReference',
              title:'参考值',
              editor:'text'
            
            },
            { 
              field:'TSex',
              title:'性别',
              width:70,
              formatter:function(value,row){
                        return row.TSexname;
                    },
              editor:{
                    type:'combobox',
                    options:{
                        valueField:'id',
                        textField:'text',
                        data:[
                            {id:'N',text:'不限'},{id:'M',text:'男'},{id:'F',text:'女'}
                        ]
                        
                    }
                }
            },
            {
	            field:'TNoBloodFlag',
	            title:'非血',
            	editor:{
	            	type:'icheckbox',
            		options:{on:'Y',off:'N'}
            	}
            
            },
            {
	            field:'TAgeRange', 
            	title:'年龄',
            	editor:'text'
            },
            {
	            field:'TAfterBracket',
	            title:'括号',
            	editor:{
                    type:'combobox',
                    options:{
                        valueField:'id',
                        textField:'text',
                        data:[
                            {id:')',text:')'},{id:'))',text:'))'},{id:')))',text:')))'},{id:'))))',text:'))))'},{id:')))))',text:')))))'}
                        ]
                        
                    }
              }},
            {
	            field:'TRelation',
	            title:'关系',
	            width:70,
            	editor:{
                    type:'combobox',
                    options:{
                        valueField:'id',
                        textField:'text',
                        data:[
                            {id:'||',text:'或者'},{id:'&&',text:'并且'}
                        ]
                        
                    }
                }
            },
            {  
	            field:'TAdd',
	            title:'插入一行',
	            width:90,
             	editor:{
	             	type:'linkbutton',
	             	options:{text:'插入一行',
	             	handler:function(){
                		var NewConditioneditIndex=ConditioneditIndex+1;
                		ConditionendEditing();
               			$('#DHCPEEDCondition').datagrid('insertRow',{
                   			 index: NewConditioneditIndex,
                   			 row: {
                        		TPreBracket:"",
                        		TItemID:"",
                        		TOperator:"",
                       		 	TReference:"",
                        		TSex:"",
                        		TNoBloodFlag:"",
                        		TAgeRange:"",
                       		 TAfterBracket:"",
                       		 TRelation:"",
                        		TAdd:"增加一行",
                        		TDelete:"删除一行"
                        		}
                    	});
                		$('#DHCPEEDCondition').datagrid('selectRow',NewConditioneditIndex).datagrid('beginEdit',NewConditioneditIndex);
                		ConditioneditIndex = NewConditioneditIndex;
                
                	}}
                	}
            
            },
            {
	            field:'TDelete',
	            title:'删除一行',
	            width:90,
           		editor:{
	           		type:'linkbutton',
	           		options:{text:'删除一行',
	           		handler:function(){
               			 $('#DHCPEEDCondition').datagrid('deleteRow',ConditioneditIndex);
                		ConditioneditIndex = undefined;
                
                	}}
                }
            }
        ]],
        onAfterEdit:function(rowIndex,rowData,changes){
               
        },
        onSelect: function (rowIndex, rowData) {
            
        }
            
    });

}
 
//初始化疾病与建议对照界面
function InitIDRelateGrid(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	//var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	
	 $HUI.datagrid("#DHCPEIDRelate",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        singleSelect: true,
        selectOnCheck: false,
        onClickRow: RelateClickRow,
        queryParams:{
            ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"EDCondition",
            ParrefRowId:"",
            EDID:""
        },
        columns:[[
            {field:'TRowID',hidden: true},  
            {field:'TEDID',hidden: true},
            {field:'TILLNessID',title:'疾病描述',width:250,
                    formatter:function(value,row){
                        return row.TILLNessDesc;
                    },
                    editor:{
                    type:'combobox',
                    options:{
                        valueField:'HIDDEN',
                        textField:'Detail',
                        //method:'get',
                        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindILLByAlias&ResultSetType=array&LocID="+LocID,
                        onBeforeLoad:function(param){
	                        param.Desc= param.q;
                            
                            
                            }
                        
                    }
                }
            },
            {field:'TEDDesc',title:'建议描述',width:170},
            {field:'TEDCode',title:'建议编码'},
            {
                field: 'TNoActive',
                width: '80',
                title: '激活',
                align:'center',
                editor: {
                    type: 'checkbox',
                    options: {
                         on:'Y',
                        off:'N'
                    }
                        
                }
            }
            
        ]],
        onAfterEdit:function(rowIndex,rowData,changes){
            
            
            var RowID=rowData.TRowID
            var EDID=rowData.TEDID
            var IllID=rowData.TILLNessID
            var NoActiveFlag=rowData.TNoActive;
            
            var InString=RowID+"^"+EDID+"^"+IllID+"^"+NoActiveFlag;
            
            var Return=tkMakeServerCall("web.DHCPE.CT.IllnessStandard","UpdateIDR",InString,tableNameIDR,UserId,$("#LocList").combobox('getValue'),"N");
            var flag=Return.split("^")[0]
            if (flag==0)
            {
                $("#DHCPEIDRelate").datagrid("load",{ClassName:"web.DHCPE.CT.IllnessStandard",QueryName:"EDCondition",ParrefRowId:"",EDID:rowData.TEDID,NoActiveFlag:NoActiveFlag,tableName:tableNameIDR,LocID:$("#LocList").combobox('getValue') }); 
            
            }
        
            
        },
        toolbar:[{
            iconCls:'icon-add',
            text:'新增',
            handler: function(){

                RelatedendEditing();
                if(RelateditIndex != undefined)
                {
                    $.messager.alert("提示","还有未保存的数据，请点击修改!","info");    
                    return
                    
                }
                else
                {
                $('#DHCPEIDRelate').datagrid('insertRow',{
                    index: 0,
                    row: {
                        TRowID: '',
                        TEDID: getValueById("ParrefRowId"),
                        TILLNessID: ''
                        }
                });
                RelateClickRow(0);
                }
            }
        },{
            iconCls:'icon-write-order',
            text:'修改',
            handler: function(){
                
                RelatedendEditing();
                
                
            }
        }
        /*{
            iconCls:'icon-cancel',
            text:'删除',
            handler: function(){
                
                
                var InString=getValueById("RelateID")
                var EDID=getValueById("ParrefRowId")
                if(InString=="")
                {
                    $.messager.alert("提示","请选择删除的行!","info");   
                    return
                }
                var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","UpdateIDR",InString,1);
                if (flag==0)
                {
                    $("#DHCPEIDRelate").datagrid("load",{ClassName:"web.DHCPE.IllnessStandard",QueryName:"EDCondition",ParrefRowId:"",EDID:EDID}); 
            
                }
                RelatedendEditing();
                
            }
        }
        */
        ],
        onSelect: function (rowIndex, rowData) {
            
            
            setValueById("RelateID",rowData.TRowID)
        }
            
    });
        	
}    
  
//初始化建议别名维护
function InitEDAliasGrid(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	//var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

	$HUI.datagrid("#DHCPEEDAlias",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        singleSelect: true,
        selectOnCheck: false,
        onClickRow: AliasClickRow,
        queryParams:{
            ClassName:"web.DHCPE.DHCPEExpertDiagnosis",
            QueryName:"EDAliasList",
            EDId:""
                
        },
        columns:[[
            {field:'EDA_RowId',hidden: true},   
            {field:'EDA_ED_DR',hidden: true},   
            {field:'EDA_Text',title:'别名',width:260,editor:'text'}
            
            
            
        ]],
        onAfterEdit:function(rowIndex,rowData,changes){
            
            var RowId=rowData.EDA_RowId
            var EDId=rowData.EDA_ED_DR
            var Alias=rowData.EDA_Text
            if(Alias=="")
            {
                $.messager.alert("提示","别名不能为空!","info");    
                    return
                
            }
            var DataStr=RowId+"^"+EDId+"^"+Alias
            var flag=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","UpdateAlias",DataStr,0);
            if (flag==0)
            {
                $("#DHCPEEDAlias").datagrid("load",{ClassName:"web.DHCPE.DHCPEExpertDiagnosis",QueryName:"EDAliasList",EDId:EDId}); 
            }
            
        },
        toolbar:[{
            iconCls:'icon-add',
            text:'新增',
            handler: function(){
                
                $('#DHCPEEDAlias').datagrid('insertRow',{
                    index: 0,
                    row: {
                        EDA_RowId: '',
                        EDA_ED_DR: getValueById("ParrefRowId"),
                        EDA_Text: ''
                        }
                });
                AliasClickRow(0);
            }
        },{
            iconCls:'icon-write-order',
            text:'修改',
            handler: function(){
                endEditing();
                
            }
        },{
            iconCls:'icon-cancel',
            text:'删除',
            handler: function(){
                
                var EDARowId=getValueById("EDARowId")
                var EDId=getValueById("ParrefRowId")
                if(EDARowId=="")
                {
                    $.messager.alert("提示","请选择删除的行!","info");   
                    return
                }
                var flag=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","UpdateAlias",EDARowId,1);
                if (flag==0)
                {
                    $("#DHCPEEDAlias").datagrid("load",{ClassName:"web.DHCPE.DHCPEExpertDiagnosis",QueryName:"EDAliasList",EDId:EDId}); 
                }
                
            }
        }
        ],
        onSelect: function (rowIndex, rowData) {
            
            setValueById("EDARowId",rowData.EDA_RowId)
        }
            
    });
	
}   
  
 //初始化专家建议Grid
function InitExpertDiagnosisGrid(){

	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	 $HUI.datagrid("#ExpertDiagnosisGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,   
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",
        singleSelect: true,
        selectOnCheck: false,
        queryParams:{
            ClassName:"web.DHCPE.CT.ExpertDiagnosis",
            QueryName:"QueryED",
            Code:"",
            DiagnoseConclusion:"",
            Alias:"",
            StationID:"", 
            ChartID:"",
            HighRisk:"",
            ActiveFlag:$HUI.checkbox("#ActiveFlag").getValue() ? "Y" : "",
            StationName:"",
            tableName:tableName, 
            LocID:LocID
                
        },
        columns:[[
            {field:'ED_RowId',hidden: true},    
            {field:'ED_DiagnoseConclusion',title:'结论'},
            {field:'ED_Detail',title:'建议'},
            {field:'TStationName',title:'站点名称'},
            {field:'TActive',title:'激活',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
       		},
            {field:'TLevel',title:'建议等级'},
            {field:'TSex',title:'性别'},
            {field:'THighRisk',title:'高危',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
            },
            {field:'TYGFlag',title:'乙肝',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
            },
            {field:'TEmpower',title:'单独授权',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
	    },{ field:'TEffPowerFlag',width:100,align:'center',title:'当前科室授权',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}
	    }
        ]],
        
        toolbar:[{
            iconCls:'icon-add',
            text:'新增',
            handler: function(){
                addExpertDiagnosis();
                
            }
        },{
            iconCls:'icon-write-order',
            text:'修改',
            handler: function(){
                updateExpertDiagnosis();
                
            }
        },{
            iconCls:'icon-paper-blue-line',
            text:'排斥',
            handler: function(){
                
                PCExpertDiagnosis();
                
            }
        },{
            iconCls:'icon-key',
            text:'数据关联科室',
            disabled:true,
            id:'BRelateLoc',
            handler: function(){
                
                BRelateLoc_click();
                
            }
        }],
        onSelect: function (rowIndex, rowData) {
            
            setValueById("ParrefRowId",rowData.ED_RowId)
            
            
            if((rowData.TEmpower=="Y")&&(rowData.TActive=="Y")){      
                    $("#BRelateLoc").linkbutton('enable');
                }else{
                    $("#BRelateLoc").linkbutton('disable');
                }
            $("#DHCPEEDAlias").datagrid("load",{ClassName:"web.DHCPE.DHCPEExpertDiagnosis",QueryName:"EDAliasList",EDId:rowData.ED_RowId}); 
            $("#DHCPEIDRelate").datagrid("load",{ClassName:"web.DHCPE.CT.IllnessStandard",QueryName:"EDCondition",ParrefRowId:"",EDID:rowData.ED_RowId}); 
            $("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:rowData.ED_RowId,Type:""}); 
            $("#NorInfo").val("");
            ConditionendEditing();
            endEditing();
            RelatedendEditing();
        },
        onLoadSuccess:function(data){
            
            setValueById("ParrefRowId","")
            $("#DHCPEEDAlias").datagrid("load",{ClassName:"web.DHCPE.DHCPEExpertDiagnosis",QueryName:"EDAliasList",EDId:""}); 
            $("#DHCPEIDRelate").datagrid("load",{ClassName:"web.DHCPE.CT.IllnessStandard",QueryName:"EDCondition",ParrefRowId:"",EDID:""}); 
            $("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:"",Type:""}); 
            $("#NorInfo").val("");
            ConditionendEditing();
            endEditing();
            RelatedendEditing();
            
        }
            
    });
}
//初始化排斥建议界面
function InitPCExpertDiagnosisGrid(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	//var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	
	 $HUI.datagrid("#PCExpertDiagnosisGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        singleSelect: true,
        selectOnCheck: false,
        onClickRow: PCClickRow,
        
        queryParams:{
            ClassName:"web.DHCPE.EDBlackBall",
            QueryName:"QueryAll",
            Parref:""
                
        },
        columns:[[
            {field:'TID',hidden: true},
            {field:'TEDID',title:'结论',width:170,
            
            formatter:function(value,row){
                        return row.TDesc;
                    },
            editor:{
                    type:'combogrid',
                    options:{
                        
                        panelWidth:300,
                        panelHeight:250,
                        url:$URL+"?ClassName=web.DHCPE.CT.ExpertDiagnosis&QueryName=QueryED",
                        mode:'remote',
                        delay:200,
                        idField:'ED_RowId',
        				textField:'ED_DiagnoseConclusion',
                        pagination:true,
                        pageSize:5,
                        pageList:[5,10],
                        displayMsg:"",
                        onBeforeLoad:function(param){
                             param.DiagnoseConclusion = param.q;
            				 param.LocID=LocID;
           					 param.Eff="Y";
                        },
        
                        columns:[[
                            {field:'ED_RowId',hidden:true},
                            {field:'ED_DiagnoseConclusion',title:'名称',width:180},
                            {field:'ED_Code',title:'编码',width:100}
            
                        ]]
                        
                        
                        
                    }
            }
            
            },  
            {field:'TCode',title:'编码',width:100},
            {field:'TDetail',title:'建议',width:200}
            
            
        ]],
        toolbar:[{
            iconCls:'icon-add',
            text:'新增',
            handler: function(){
                
                
                
                if(PCeditIndex != undefined)
                {
                    $.messager.alert("提示","还有未保存的数据，请点击修改!","info");    
                    return
                    
                }
                else
                {
                var rows = $("#PCExpertDiagnosisGrid").datagrid("getRows");
                $('#PCExpertDiagnosisGrid').datagrid('insertRow',{
                    index: 0,
                    row: {
                        TID: '',
                        TEDID: '',
                        TCode: '',
                        TDetail: ''
                        }
                });
                
                PCClickRow(0);
                
                }
            }
        },{
            iconCls:'icon-write-order',
            text:'修改',
            handler: function(){
                PCendEditing();
            }
        },{
            iconCls:'icon-cancel',
            text:'删除',
            handler: function(){
                
                var ID=getValueById("PCRowId")
                var Parref=getValueById("ParrefRowId")
                if(ID=="")
                {
                    $.messager.alert("提示","请选择删除的行!","info");   
                    return
                }
                var flag=tkMakeServerCall("web.DHCPE.EDBlackBall","DeleteBlackBall",ID);
                if (flag==0)
                {
                    $("#PCExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.EDBlackBall",QueryName:"QueryAll",Parref:Parref}); 

                    PCeditIndex=undefined;
                }
                
                
            }
        }
        ],
        onAfterEdit:function(rowIndex,rowData,changes){
            
            var ID=rowData.TID
            var Parref=getValueById("ParrefRowId")
            var EDID=rowData.TEDID
            
            var flag=tkMakeServerCall("web.DHCPE.EDBlackBall","UpdateBlackBall",ID,Parref,EDID);
            if (flag==0)
            {
                $("#PCExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.EDBlackBall",QueryName:"QueryAll",Parref:Parref}); 

            }
            else 
            {
                $.messager.alert("提示",flag,"info"); 
                $("#PCExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.EDBlackBall",QueryName:"QueryAll",Parref:Parref}); 

            }
            
        },
        onSelect: function (rowIndex, rowData) {
            setValueById("PCRowId",rowData.TID)
            
        }
            
    });
        
	
}	
	   
//科室下拉列表change   
function LocList_Change(){
		 Find_click();
	  	
	  	var LocID=session['LOGON.CTLOCID']
		var LocListID=$("#LocList").combobox('getValue');
		if(LocListID!=""){var LocID=LocListID; }
		var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		
		/*****************知识库同步按钮是否显示*****************/
		var HospTagsCode = tkMakeServerCall("web.DHCPE.HISUICommon","GetHospTagsCode",LocID);
		if (HospTagsCode){
			$("#KBSynchro").show()
		}
		/*****************知识库同步按钮是否显示*****************/
		
		/*****************级别重新加载(combobox)*****************/
		var DiagnosisLevelurl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=DiagnosisLevel&ResultSetType=array&LocID="+LocID;
		$('#NDiagnosisLevel').combobox('reload',DiagnosisLevelurl);
		/*****************安全组重新加载(combobox)*****************/
		
		/*****************站点重新加载(combobox)*****************/
		 var Stationurl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID;
		$('#StationID').combobox('reload',Stationurl);
		/*****************安全组重新加载(combobox)*****************/
		    
		    
		 /*****************站点(弹窗)重新加载(combobox)*****************/
		 var NStationIDurl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID="+LocID;
		$('#NStationID').combobox('reload',NStationIDurl);
		/*****************安全组重新加载(combobox)*****************/
		
		/********************分组名称重新加载combogrid****************************/
		$("#NStationLoc").combogrid('setValue',"");
	  	$HUI.combogrid("#NStationLoc",{
			onBeforeLoad:function(param){
				var STId=$("#NStationID").combobox("getValue");
            	param.StationID = STId;
           	 	param.LocID = LocID;
            	param.Desc= param.q;

			}
		});
		    
		$('#NStationLoc').combogrid('grid').datagrid('reload'); 
	   /********************分组名称重新加载combogrid****************************/
	  	InitEDConditionGrid();
	  	ConditioneditIndex = undefined;
	  	
	  	InitIDRelateGrid();
	  	RelateditIndex=undefined;
	  	
	  	editIndex=undefined;
		PCeditIndex=undefined;

 }   