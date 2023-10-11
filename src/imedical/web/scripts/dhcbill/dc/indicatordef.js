/**
 * 指标维护
 * FileName: dhcbill\dc\indicatordef.js
 * tangzf 2022-05-11
 */
 var GV = {
    CLASSNAME:"BILL.DC.BL.IndicatorDefCtl"   
}
//全局变量
var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
var HospDr = session['LOGON.HOSPID'];
var TimeOut=null;
$(function(){
    var tableName = "User.INSUTarContrast";
    var defHospId = session['LOGON.HOSPID'];//
    $("#hospital").combobox({
        panelHeight: 150,
        url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
        method: 'GET',
        valueField: 'HOSPRowId',
        textField: 'HOSPDesc',
        editable: false,
        blurValidValue: true,
        onLoadSuccess: function(data) {
            $(this).combobox('select', defHospId);
        },
        onChange: function(newValue, oldValue) {
            var HISVer = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","SYS", "HISVer", newValue,"14");
            $("#QHISVer").combobox('setValue',HISVer);
        }
    });
    $HUI.combobox("#QHISVer", {
        panelHeight: 250,
        url: $URL,
        rowStyle:'checkbox',
        multiple:true,
        editable: false,
        valueField: 'DicCode',
        textField: 'DicDesc',
        defaultFilter: 4,
        onBeforeLoad: function (param) {
            param.ClassName = "BILL.DC.BL.DicDataCtl";
            param.QueryName = "QueryInfo";
            param.HospID = "G";
            param.KeyCode="";
            param.PDicType= "HISVerCode";
            param.ExpStr= "";
            param.ResultSetType = 'array';
            return true;
        },
        onLoadSuccess: function (data) {
            if (data.length > 1) {
                
            }
        },
        onChange:function(val){
            //Querydic();
        }
    });
    //初始化datagrid
    $HUI.datagrid("#dg",{
        data:[],
        fit: true,
        //idField:'dgid',
        rownumbers:true,
        striped:true,
        //fitColumns:true,
        singleSelect: true,
        autoRowHeight:false,
        border:false,
        toolbar: '#toolbar',
        columns:[[
        // Code,Name,IndicatorTypeId,BusinessTypeId,EXlevelId,Description,ActiveFlag,ExecClass,ExecClassMethod,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid
            
            {field:'Code',title:'指标代码',width:65, align: "center"},
            {field:'Name',title:'指标名称',width:300,tipPosition:"top",showTip:true},
            {field:'BusinessTypeCode',title:'业务类型',width:70,hidden:true},
            {field:'BusinessTypeDesc',title:'业务描述',tipPosition:"top",width:70,showTip:true},
            {field:'IndicatorTypeDesc',title:'指标类型',width:80},
            {field:'IndicatorTypeId',title:'指标代码',width:80,hidden:true,},
            {field:'ActiveFlag',title:'是否有效',width:70,
                formatter: function (value, row, index) {
                    var rtn = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","ActiveFlag", value, "G","2");
                    return (value == "Y") ? rtn : "<font color='#f16e57'>" + rtn +"</font>";
            }},
            {field:'EXlevelDesc',title:'异常等级',width:70},
            {field:'EXlevelId',title:'异常等级',width:70,hidden:true,},
            {field:'Description',title:'监控点说明',width:300,tipPosition:"top",showTip:true},
            {field:'HISVer',title:'HIS版本号',width:80,tipPosition:"top",showTip:true},
            {field:'CheckTypeDesc',title:'核查分类',width:140},
            {field:'CheckType',title:'核查分类',width:140,hidden:true,},
            {field:'ExecClass',title:'执行类名',width:120,hidden:true},
            {field:'ExecClassMethod',title:'类方法名',width:320,tipPosition:"top",showTip:true,hidden:true},
            {field:'HospDr',title:'院区',width:50,width:10,hidden:true},
            {field:'CRTER',title:'创建人',width:50,width:10,hidden:true},
            {field:'CRTEDATE',title:'创建日期',width:50,width:10,hidden:true},
            {field:'CRTETIME',title:'创建时间',width:50,width:10,hidden:true},
            {field:'UPDTID',title:'更新人',width:50,width:10,hidden:true},
            {field:'UPDTDATE',title:'更新日期',width:50,width:10,hidden:true},
            {field:'UPDTTIME',title:'更新时间',width:50,width:10,hidden:true},
            {field:'Rowid',title:'Rowid',width:10,hidden:true},
            {field: 'btn', title: '修改',width: 80, align: "center",
                formatter: function(value, row, index) {
                    return '<a href="#this" class="editcls1" onclick="ShowDataDetails(' + index + ')"></a>';
                }
            }
        ]],
/*      pageSize: 9999,
        pagination:false, */
        pageSize: 30,
        pagination:true,
        onClickRow : function(rowIndex, rowData) {
            //clearTimeout(TimeOut);
            //TimeOut=
            //setTimeout(function(){
                if(tmpselRow==rowIndex){
                    //clearform("1");
                    tmpselRow=-1;
                    //$(this).datagrid('unselectRow',rowIndex);
                    $(this).datagrid('unselectAll'); 
                }else{
                    //fillform(rowIndex,rowData);
                    tmpselRow=rowIndex;
                }
            //},300);
           
        },
       onDblClickRow:function(rowIndex, rowData){
            //clearTimeout(TimeOut);
            $(this).datagrid('selectRow',rowIndex);
            tmpselRow=rowIndex;
            //fillform(rowIndex,rowData);
            ShowDataDetails(rowIndex);
        },
        onUnselect: function(rowIndex, rowData) {
            //alert(rowIndex+"-"+rowData.itemid)
        },
        onLoadSuccess:function(data){
            $('.editcls1').linkbutton({iconCls:"icon-write-order", plain: true});
            //$('.btnedit').popover({content: "修改", placement: 'top-right', trigger: 'hover'});
        }
    });
    
    //登记号回车查询事件
    $("#dicKey").keydown(function (e) {
        var key = websys_getKey(e);
        if (key == 13) {
            clearform();
        }
    });
    clearform(1);
    clearQform(1);
    
});

function init_ActiveFlagCB(){
    $HUI.combobox("#ActiveFlag", {
        panelHeight: 150,
        url: $URL,
        editable: false,
        valueField: 'DicCode',
        textField: 'DicDesc',
        defaultFilter: 4,
        onBeforeLoad: function (param) {
            param.ClassName = "BILL.DC.BL.DicDataCtl";
            param.QueryName = "QueryInfo";
            param.HospID = "G";
            param.KeyCode="";
            param.PDicType= "ActiveFlag";
            param.ExpStr= "";
            param.ResultSetType = 'array';
            return true;
        },
        onSelect: function (data) {
        }
    });
}
function init_IndicatorTypeIdCB(){
    $HUI.combobox("#IndicatorTypeId", {
        panelHeight: 150,
        url: $URL,
        editable: false,
        valueField: 'DicCode',
        textField: 'DicDesc',
        defaultFilter: 4,
        onBeforeLoad: function (param) {
            param.ClassName = "BILL.DC.BL.DicDataCtl";
            param.QueryName = "QueryInfo";
            param.HospID = "G";
            param.KeyCode="";
            param.PDicType= "IndiType";
            param.ResultSetType = 'array';
            return true;
        },
        onLoadSuccess: function (data) {
            /* if (data.length > 1) {
                $(this).combobox("select", data[0].DicCode);
            } */
        }
    });
}

function init_HISVer(){
    $HUI.combobox("#HISVer", {
    panelHeight: 300,
    url: $URL,
    editable: false,
    valueField: 'DicCode',
    textField: 'DicDesc',
    defaultFilter: 4,
    rowStyle:'checkbox',
    multiple:true,
    onBeforeLoad: function (param) {
        param.ClassName = "BILL.DC.BL.DicDataCtl";
        param.QueryName = "QueryInfo";
        param.HospID = "G";
        param.KeyCode="";
        param.PDicType= "HISVerCode";
        param.ExpStr= "";
        param.ResultSetType = 'array';
        return true;
    },
    onLoadSuccess: function (data) {
        /* if (data.length > 1) {
            $(this).combobox("select", data[0].DicCode);
        } */
    },
    onChange:function(val){
    }
    });
    
}


function init_EXlevelIdCB(){
    $HUI.combobox("#EXlevelId", {
    panelHeight: 150,
    url: $URL,
    editable: false,
    valueField: 'DicCode',
    textField: 'DicDesc',
    defaultFilter: 4,
    onBeforeLoad: function (param) {
        param.ClassName = "BILL.DC.BL.DicDataCtl";
        param.QueryName = "QueryInfo";
        param.HospID = "G";
        param.KeyCode="";
        param.PDicType= "ExceptionLevel";
        param.ExpStr= "";
        param.ResultSetType = 'array';
        return true;
    },
    onLoadSuccess: function (data) {
        /* if (data.length > 1) {
            $(this).combobox("select", data[0].DicCode);
        } */
    },
    onChange:function(val){
        /* if(selRowid <= 0){
            var rtn = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","ExceptionLevel", val, HospDr,"2");
            setValueById('Code',rtn);   
        } */
    }
    });
}
function init_BusinessTypeIdCB(){
    $HUI.combobox("#BusinessTypeCode", {
        panelHeight: 150,
        url: $URL,
        editable: false,
        valueField: 'DicCode',
        textField: 'DicDesc',
        defaultFilter: 4,
        onBeforeLoad: function (param) {
            param.ClassName = "BILL.DC.BL.DicDataCtl";
            param.QueryName = "QueryInfo";
            param.HospID = "G";
            param.KeyCode="";
            param.PDicType= "BusinessTypeCode";
            param.ResultSetType = 'array';
            return true;
        },
        onLoadSuccess: function (data) {
            /* if (data.length > 1) {
                $(this).combobox("select", data[0].DicCode);
            } */
        },
        onChange:function(val){
            if(selRowid <= 0){
                    
            }
            
        },
        onSelect:function(){
            /* var rtn = tkMakeServerCall("BILL.DC.BL.IndicatorDefCtl","GetNewIndiCode",HospDr,getValueById('ActiveFlag'),getValueById("BusinessTypeCode"));
            setValueById('Code',rtn); */                
        }
    });
}

function init_QBusinessTypeIdCB(){
    $HUI.combobox("#QBusinessType", {
        panelHeight: 150,
        url: $URL,
        valueField: 'DicCode',
        textField: 'DicDesc',
        defaultFilter: 4,
        onBeforeLoad: function (param) {
            param.ClassName = "BILL.DC.BL.DicDataCtl";
            param.QueryName = "QueryInfo";
            param.HospID = "G";
            param.KeyCode="";
            param.PDicType= "BusinessTypeCode";
            param.ResultSetType = 'array';
            return true;
        },
        onLoadSuccess: function (data) {
        },
        onChange:function(val){
            //Querydic();
        }
    });
}
function init_CheckTypeCB(){
    $HUI.combobox("#CheckType", {
        panelHeight: 150,
        url: $URL,
        editable: false,
        valueField: 'DicCode',
        textField: 'DicDesc',
        defaultFilter: 4,
        onBeforeLoad: function (param) {
            param.ClassName = "BILL.DC.BL.DicDataCtl";
            param.QueryName = "QueryInfo";
            param.HospID = "G";
            param.KeyCode="";
            param.PDicType= "CheckType";
            param.ExpStr= "";
            param.ResultSetType = 'array';
            return true;
        },
        onLoadSuccess: function (data) {
            /* if (data.length > 1) {
                $(this).combobox("select", data[0].DicCode);
            } */
        },
        onChange:function(val){
            /* if(selRowid <= 0){
                var rtn = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","IndiType", val, HospDr,"2");
                setValueById('Code',rtn);   
            } */
        }
    });
}

function init_QCheckTypeCB(){
    $HUI.combobox("#QCheckType", {
        panelHeight: 150,
        url: $URL,
        valueField: 'DicCode',
        textField: 'DicDesc',
        defaultFilter: 4,
        onBeforeLoad: function (param) {
            param.ClassName = "BILL.DC.BL.DicDataCtl";
            param.QueryName = "QueryInfo";
            param.HospID = "G";
            param.KeyCode="";
            param.PDicType= "CheckType";
            param.ExpStr= "";
            param.ResultSetType = 'array';
            return true;
        },
        onLoadSuccess: function (data) {

        },
        onChange:function(val){
            //Querydic();
        }
    });
}

function init_QExceptionLevalCB(){
    $HUI.combobox("#QExceptionLeval", {
        panelHeight: 150,
        url: $URL,
        valueField: 'DicCode',
        textField: 'DicDesc',
        defaultFilter: 4,
        onBeforeLoad: function (param) {
            param.ClassName = "BILL.DC.BL.DicDataCtl";
            param.QueryName = "QueryInfo";
            param.HospID = "G";
            param.KeyCode="";
            param.PDicType= "ExceptionLevel";
            param.ExpStr= "";
            param.ResultSetType = 'array';
            return true;
        },
        onLoadSuccess: function (data) {

        },
        onChange:function(val){
            //Querydic();
        }
    });
}


//查询字典数据
function Querydic(){
    //clearform('1');
    $('#dg').datagrid('loadData',{total:0,rows:[]});
    // tangzf 2020-6-17 使用HISUI接口 加载数据
    var a= $('#QHISVer').combobox('getValues');
    var QueryParam={
        ClassName: GV.CLASSNAME,
        QueryName: 'QueryInfo',
        KeyCode:getValueById('dicKey'),
        HospID :  "",
        QHISVer:""+$('#QHISVer').combobox('getValues'),     
        PCheckType:getValueById('QCheckType'),
        QExceptionLeval:getValueById('QExceptionLeval'),
        QBusinessType:getValueById('QBusinessType')
    }
    loadDataGridStore('dg',QueryParam);
    
}
//特殊字符处理
function SplVCFormat(FStr)
{
    return  FStr.replace(/\^/g,"");
}
//停用保存记录
function StopDic(){
    if(selRowid=="" || selRowid<0 || !selRowid){
        $.messager.alert('提示','请选择要停用的指标!','info'); 
        return;  
    }
    if(getValueById('ActiveFlag')=="N")
    {
        $.messager.alert('提示','指标已停用!','info'); 
        return;
    }
    $.messager.confirm("提示", "是否停用？", function (r) { // prompt 此处需要考虑为非阻塞的
    if (r) {
        var Code = getValueById('Code');
        var Name = getValueById('Name');
        var IndicatorTypeId = getValueById('IndicatorTypeId');
        var CheckType = getValueById('CheckType'); // CheckType
        var EXlevelId = getValueById('EXlevelId');
        var Description = getValueById('Description');
        var ActiveFlag = "N";//getValueById('ActiveFlag');
        var ExecClass = getValueById('ExecClass');
        var ExecClassMethod = getValueById('ExecClassMethod');
        var HospDr = "G";
        var CRTER = getValueById('CRTER');
        var CRTEDATE = getValueById('CRTEDATE');
        var CRTETIME = getValueById('CRTETIME');
        var UPDTID = getValueById('UPDTID');
        var UPDTDATE = getValueById('UPDTDATE');
        var UPDTTIME = getValueById('UPDTTIME');
        var Rowid = getValueById('Rowid');
        var BusinessTypeCode = getValueById('BusinessTypeCode');
        var HISVer = $('#HISVer').combobox('getValues');
        selRowid = selRowid<0?"":selRowid;
        var saveinfo=selRowid+"^"+Code+"^"+Name+"^"+IndicatorTypeId+"^"+CheckType+"^"+EXlevelId+"^"+Description+"^"+ActiveFlag+"^"+ExecClass+"^"+ExecClassMethod+"^"+HospDr+"^"+CRTER+"^"+CRTEDATE+"^"+CRTETIME+"^"+UPDTID+"^"+UPDTDATE+"^"+UPDTTIME;
        saveinfo = saveinfo + "^" + BusinessTypeCode+"^"+HISVer;
        saveinfo=saveinfo.replace(/请输入信息/g,"")
        var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
        if(savecode.split("^")[0]>0){
            //$.messager.alert('提示','保存成功!');  
            $("#dg").datagrid('reload')
            $("#dg").datagrid('unselectAll')
            clearform()
            $.messager.alert('提示','停用成功!','info');   
        }else{
            $.messager.alert('提示','停用失败!rtn=' + savecode,'info');   
        }
    } else {
        return false;
    }
    })

}


//更新保存记录
function UpdateDic(){
    var Code = getValueById('Code');
    var Name = getValueById('Name');
    var IndicatorTypeId = getValueById('IndicatorTypeId');
    var CheckType = getValueById('CheckType'); // CheckType
    var EXlevelId = getValueById('EXlevelId');
    var Description = getValueById('Description');//.replace(/\n/g,"此处回车符");
    var ActiveFlag = getValueById('ActiveFlag');
    var ExecClass = getValueById('ExecClass');
    var ExecClassMethod = getValueById('ExecClassMethod');
    var HospDr = "G";
    var CRTER = getValueById('CRTER');
    var CRTEDATE = getValueById('CRTEDATE');
    var CRTETIME = getValueById('CRTETIME');
    var UPDTID = getValueById('UPDTID');
    var UPDTDATE = getValueById('UPDTDATE');
    var UPDTTIME = getValueById('UPDTTIME');
    var Rowid = getValueById('Rowid');
    var BusinessTypeCode = getValueById('BusinessTypeCode');
    var HISVer = $('#HISVer').combobox('getValues');
    selRowid = selRowid<0?"":selRowid;
    var saveinfo=selRowid+"^"+Code+"^"+Name+"^"+IndicatorTypeId+"^"+CheckType+"^"+EXlevelId+"^"+Description+"^"+ActiveFlag+"^"+ExecClass+"^"+ExecClassMethod+"^"+HospDr+"^"+CRTER+"^"+CRTEDATE+"^"+CRTETIME+"^"+UPDTID+"^"+UPDTDATE+"^"+UPDTTIME;
    saveinfo = saveinfo + "^" + BusinessTypeCode+"^"+HISVer;
    saveinfo=saveinfo.replace(/请输入信息/g,"")
    ///alert(saveinfo)
    var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
    //alert(savecode)
    if(savecode.split("^")[0]>0){
        //$.messager.alert('提示','保存成功!');  
        if (selRowid)
        {
            $('#dg').datagrid('updateRow',{
                index: tmpselRow,
                row: {
                    id:'<a href="#this" class="editcls1" onclick="ShowDataDetails(' + tmpselRow + ')"></a>',
                    Code: getValueById('Code'),
                    //Name: getValueById('Name'),
                    BusinessTypeCode:getValueById('BusinessTypeCode'),
                    BusinessTypeDesc:$('#BusinessTypeCode').combobox("getText"),
                    IndicatorTypeId:getValueById('IndicatorTypeId'),
                    ActiveFlag:getValueById('ActiveFlag'),
                    EXlevelId:getValueById('EXlevelId'),
                    Description:getValueById('Description'),
                    HISVer:$('#HISVer').combobox("getText"),
                    CheckType:getValueById('CheckType'),
                    ExecClass:getValueById('ExecClass'),
                    ExecClassMethod:getValueById('ExecClassMethod')
                }
            });
            $('.editcls1').linkbutton({iconCls:"icon-write-order", plain: true});
        }
        else
        {
            $("#dg").datagrid('reload');
        }
        $("#dg").datagrid('unselectAll')
        //clearform('1')
        $.messager.alert('提示','保存成功!','info');   
    }else{
        $.messager.alert('提示','保存失败!rtn=' + savecode,'info');   
    }
    $('#DatadetailedForm').dialog('close');
}
//删除记录
function DelDic(){
    //if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
    if(selRowid=="" || selRowid<0 || !selRowid){$.messager.alert('提示','请选择要删除的记录!','info');return;}
    $.messager.confirm('请确认','你确认要删除这条记录吗?',function(fb){
        if(fb){
            var savecode=tkMakeServerCall(GV.CLASSNAME,"Delete",selRowid)
            if(eval(savecode)==0){
                $.messager.alert('提示','删除成功!','info');   
                $("#dg").datagrid('reload')
                selRowid="";
                $("#dg").datagrid("getPager").pagination('refresh');
                $("#dg").datagrid('unselectAll')
            }else{
                $.messager.alert('提示','删除失败!','info');   
            }
        }else{
            return; 
        }
    });
}
//填充下边的form
/* function fillform(rowIndex,rowData){
    selRowid=rowData.Rowid
    // Code,Name,IndicatorTypeId,BusinessTypeId,EXlevelId,Description,ActiveFlag,ExecClass,ExecClassMethod,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid
    setValueById('Code',rowData.Code);
    setValueById('Name',rowData.Name);
    setValueById('IndicatorTypeId',rowData.IndicatorTypeId);
    setValueById('CheckType',rowData.CheckType);
    setValueById('EXlevelId',rowData.EXlevelId);
    setValueById('Description',rowData.Description);
    setValueById('ActiveFlag',rowData.ActiveFlag);
    setValueById('ExecClass',rowData.ExecClass);
    setValueById('ExecClassMethod',rowData.ExecClassMethod);
    setValueById('HospDr',rowData.HospDr);
    setValueById('BusinessTypeCode',rowData.BusinessTypeCode);
    $('#HISVer').combobox('setValues',rowData.HISVer.split(','));
} */
//清除下边的form
function clearform(inArgs){
    $('.editinfo input').each(function(){        
        $(this).val('');
    })
    tmpselRow = -1;
    selRowid="";
    if(inArgs){
        /* var data=$('#dg').datagrid('getSelected');
        if (data!="")
        {
            return;
        } */
    }
    if(!inArgs){
        Querydic(); 
    } 

    init_EXlevelIdCB();
    init_HISVer();
    init_BusinessTypeIdCB();
    init_IndicatorTypeIdCB();
    init_ActiveFlagCB();
    init_CheckTypeCB();
    setValueById('ExecClass','');
    setValueById('Name','');
    setValueById('Code',''); 
    //$('#Code').validatebox('validate');

}

function ShowClearEdit(){
    setValueById('Name',"");
    
    setValueById('CheckType',"");
    setValueById('BusinessTypeCode',"");
    setValueById('ActiveFlag',"");
    
    setValueById('Code',"");
    setValueById('EXlevelId',"");
    setValueById('IndicatorTypeId',"");
    
    setValueById('ExecClass',"");
    setValueById('ExecClassMethod',"");
    //setValueById('HISVer',"");
    $('#HISVer').combobox('setValue',"");
    setValueById('Description',"");
    $('#DatadetailedForm').dialog({
             title: '新增',
             iconCls: 'icon-w-edit',
             modal: true
         }).dialog('open')
}
//显示弹框展示指标明细内容
function ShowDataDetails(index){
	clearform(1);
    var rowData=$("#dg").datagrid("getData").rows[index];
    selRowid=rowData.Rowid;
    tmpselRow=index;
    
    setValueById('Name',rowData.Name);
    
    setValueById('CheckType',rowData.CheckType);
    setValueById('BusinessTypeCode',rowData.BusinessTypeCode);
    setValueById('ActiveFlag',rowData.ActiveFlag);
    
    setValueById('Code',rowData.Code);
    setValueById('EXlevelId',rowData.EXlevelId);
    setValueById('IndicatorTypeId',rowData.IndicatorTypeId);
    
    setValueById('ExecClass',rowData.ExecClass);
    setValueById('ExecClassMethod',rowData.ExecClassMethod);
    
    /* var HisVerStr=rowData.HISVer;
    if(rowData.HISVer.indexOf(",")!=-1)
    {
        HisVerStr="";
        var HISList=rowData.HISVer.split(',');
        for(var i=0; i<HISList.length;i++)
        {
            HisVerStr=HisVerStr+HISList[i]+"，";
            if((i+1)%3==0)//三个换行一次
            {
                HisVerStr=HisVerStr+"\r\n";
            }
        }
    }
    setValueById('HISVer',HisVerStr); */
    if(rowData.HISVer.indexOf(",")!=-1)
    {
        $('#HISVer').combobox('setValues',rowData.HISVer.split(','));
    }
    else
    {
        setValueById('HISVer',rowData.HISVer);
    }
    setValueById('Description',rowData.Description);
   // var re=\n
   // var indexOf=rowData.Description.replace(/\n/g,"此处回车符")
    
    $('#DatadetailedForm').dialog({
             //title: '增加',
             iconCls: 'icon-w-edit',
             modal: true
    }).dialog('open')
}

//指标维护字典导出
function Export()
{
   try
   {
        $.messager.progress({
             title: "提示",
             msg: '正在导出指标维护字典数据',
             text: '导出中....'
               });
        $cm({
            ResultSetType:"ExcelPlugin",  
            ExcelName:"指标维护字典",       
            ClassName: GV.CLASSNAME,
            QueryName: 'QueryInfo',
            HospID :  "",
            Export : '1'
        },function(data){
              setTimeout('$.messager.progress("close");', 3 * 1000);    
        });
   } catch(e) {
       $.messager.alert("警告",e.message);
       $.messager.progress('close');
   }; 
}


function Import()
{
	ImportObj.ImportFile(
		{
			FileSuffixname: /^(.xls)|(.xlsx)$/,///^(.txt)$/,
			harset: 'utf-8'
		}, function(arr){
			SaveArr(arr);
		}
	);
}
//循环调保存方法
function SaveArr(arr)
{
	var ErrMsg = "";     //错误数据
    var errRowNums = 0;  //错误行数
    var sucRowNums = 0;  //导入成功的行数
	var rowCnt=arr.length
	try{
		$.messager.progress({
            title: "提示",
            msg: '免费收费/医嘱项目配置字典导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
		for (i = 0; i < rowCnt; i++) 
		{
			var rowArr=arr[i];
			var Code = rowArr.Code?rowArr.Code:"";
			var IndicatorTypeId = rowArr.IndicatorTypeId?rowArr.IndicatorTypeId:"";
			var CheckType = rowArr.CheckType?rowArr.CheckType:"";
			var EXlevelId = rowArr.EXlevelId?rowArr.EXlevelId:"";
			var Description = rowArr.Description?rowArr.Description:"";
			var ActiveFlag = rowArr.ActiveFlag?rowArr.ActiveFlag:"";
			var ExecClass = rowArr.ExecClass?rowArr.ExecClass:"";
			var ExecClassMethod = rowArr.ExecClassMethod?rowArr.ExecClassMethod:""; 
			var HospDr = rowArr.HospDr?rowArr.HospDr:"";
			var CRTER = rowArr.CRTER?rowArr.CRTER:"";
			var CRTEDATE = rowArr.CRTEDATE?rowArr.CRTEDATE:"";
			var CRTETIME = rowArr.CRTETIME?rowArr.CRTETIME:"";
			var UPDTID = rowArr.UPDTID?rowArr.UPDTID:"";
			var UPDTDATE = rowArr.UPDTDATE?rowArr.UPDTDATE:"";
			var UPDTTIME = rowArr.UPDTTIME?rowArr.UPDTTIME:"";
			var Rowid = rowArr.Rowid?rowArr.Rowid:"";
			var BusinessTypeCode = rowArr.BusinessTypeCode?rowArr.BusinessTypeCode:""; 
			var BusinessTypeDesc = rowArr.BusinessTypeDesc?rowArr.BusinessTypeDesc:""; 
			var HISVer = rowArr.HISVer?rowArr.HISVer:""; 
			var ReferenceHISVer = rowArr.ReferenceHISVer?rowArr.ReferenceHISVer:""; 
			var IndicatorTypeDesc = rowArr.IndicatorTypeDesc?rowArr.IndicatorTypeDesc:""; 
			var EXlevelDesc = rowArr.EXlevelDesc?rowArr.EXlevelDesc:""; 
			var CheckTypeDesc = rowArr.CheckTypeDesc?rowArr.CheckTypeDesc:""; 
			var saveinfo=Rowid+"^"+Code+"^"+Name+"^"+IndicatorTypeId+"^"+CheckType+"^"+EXlevelId+"^"+Description+"^"+ActiveFlag+"^"+ExecClass+"^"+ExecClassMethod+"^"+HospDr+"^"+CRTER+"^"+CRTEDATE+"^"+CRTETIME+"^"+UPDTID+"^"+UPDTDATE+"^"+UPDTTIME;
            saveinfo = saveinfo + "^" + BusinessTypeCode+"^"+HISVer;
            var savecode = tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
            if (savecode == null || savecode == undefined) savecode = -1;
            if (savecode >= 0) {
	        	sucRowNums = sucRowNums + 1;
	        } 
	        else {
		        errRowNums = errRowNums + 1;
		        if (ErrMsg == "") {
			        ErrMsg = i+":"+savecode;
			    }
			    else {
                    ErrMsg = ErrMsg + "<br>" + i+":"+savecode+"已存在！";
                }
        	}
		}
		if (ErrMsg == "") {
        	$.messager.progress("close");
        	$.messager.alert('提示', '数据正确导入完成');
        } else {
            $.messager.progress("close");
            var tmpErrMsg = "导入成功："+sucRowNums +"条，失败："+errRowNums+"条。";
            tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>"+ ErrMsg;
            $.messager.alert('提示', tmpErrMsg,'info');
        }
	}
	catch(ex)
	{
		$.messager.progress("close");
		$.messager.alert('提示', '保存数据异常：'+ex.message,'error');
	}
}

//指标维护字典导入
function Import2()
{
    var filePath=""
    var exec= '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
               +'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
               +'if (!fName){fName="";}'
               +'xlApp.Quit();'
               +'xlSheet=null;'
               +'xlApp=null;'
               +'return fName;}());'
      CmdShell.notReturn = 0;
      var rs=CmdShell.EvalJs(exec);
      if(rs.msg == 'success'){
        filePath = rs.rtn;
        importItm(filePath);
      }else{
         $.messager.alert('提示', '打开文件错误！'+rs.msg,'error');
      }                
}

function importItm(filePath)
{
    if (filePath == "") {
        $.messager.alert('提示', '请选择文件！','info')
        return ;
    }
   $.messager.progress({
         title: "提示",
         msg: '指标维护字典导入中',
         text: '数据读取中...'
        }); 
   $.ajax({
    async : true,
    complete : function () {
    ReadItmExcel(filePath);
    }
    });
  
}
//读取Excel数据
function ReadItmExcel(filePath)
{
    
   //读取excel
   var arr;
   try 
   {
     arr= websys_ReadExcel(filePath);
     $.messager.progress("close");
    }
   catch(ex)
   {
      $.messager.progress("close");
      $.messager.alert('提示', '调用websys_ReadExcel异常：'+ex.message,'error')
      return ;
    }
     var rowCnt=arr.length
     $.messager.progress({
            title: "提示",
            msg: '指标维护字典导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
    $.ajax({
       async : true,
       complete : function () {
       ItmArrSave(arr);
    }
    });
}
//指标维护字典保存
function ItmArrSave(arr)
{
    
    //读取保存数据
    var ErrMsg = "";     //错误数据
    var errRowNums = 0;  //错误行数
    var sucRowNums = 0;  //导入成功的行数
    var rowCnt=arr.length
     try{
         for (i = 1; i < rowCnt; i++) 
         {
             var rowArr=arr[i]
             var Code = rowArr[0];
             var Name = rowArr[1];
             var IndicatorTypeId = rowArr[2];
             var CheckType = rowArr[3]; // CheckType
             var EXlevelId = rowArr[4];
             var Description = rowArr[5];
             var ActiveFlag = rowArr[6];
             var ExecClass = rowArr[7];
             var ExecClassMethod = rowArr[8];
             var HospDr = rowArr[9];
             var CRTER = rowArr[10];
             var CRTEDATE = rowArr[11];
             var CRTETIME = rowArr[12];
             var UPDTID = rowArr[13];
             var UPDTDATE = rowArr[14];
             var UPDTTIME = rowArr[15];
             var Rowid = rowArr[16];
             var BusinessTypeCode = rowArr[17];
             var HISVer = rowArr[19];
             var saveinfo=Rowid+"^"+Code+"^"+Name+"^"+IndicatorTypeId+"^"+CheckType+"^"+EXlevelId+"^"+Description+"^"+ActiveFlag+"^"+ExecClass+"^"+ExecClassMethod+"^"+HospDr+"^"+CRTER+"^"+CRTEDATE+"^"+CRTETIME+"^"+UPDTID+"^"+UPDTDATE+"^"+UPDTTIME;
             saveinfo = saveinfo + "^" + BusinessTypeCode+"^"+HISVer;
             var savecode = tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
                    if (savecode == null || savecode == undefined) savecode = -1
                    if (savecode >= 0) {
                        sucRowNums = sucRowNums + 1;
                    } else {
                        errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = i+":"+savecode;
                        } else {
                            ErrMsg = ErrMsg + "<br>" + i+":"+savecode;
                        }
                    }
         }
         if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "导入成功："+sucRowNums +"条，失败："+errRowNums+"条。";
                     tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>"+ ErrMsg;
                    $.messager.alert('提示', tmpErrMsg,'info');
                }
              return ;
         }
         catch(ex)
         {
              $.messager.progress("close");
              $.messager.alert('提示', '保存指标维护字典数据异常：'+ex.message,'error')
              return ;
          }
  return ;
    
}
//清除下边的form
function clearQform(type){
	if(type!=1){
		var defHospId = session['LOGON.HOSPID'];
		$('#hospital').combobox('select', defHospId);
		setValueById('QBusinessType','');
		setValueById('QCheckType','');
		setValueById('QExceptionLeval','');
	}
	else
	{
    	init_QBusinessTypeIdCB();
    	init_QCheckTypeCB();
   		init_QExceptionLevalCB();  
	}
    setValueById('dicKey','');
    setValueById('QHISVer','');
    Querydic();
}
function onChangeFun(){
    
}
$('.hisui-linkbutton').bind('click',function(){
     switch (this.id){ 
        case "btnUpdate" : // 保存
            if(!CheckIndiCode()){
                return;
            }
            var msgText=selRowid>0?"更新":"新增";
            $.messager.confirm("提示", "是否继续【" + msgText + "】？", function (r) { // prompt 此处需要考虑为非阻塞的
                if (r) {
                    UpdateDic();
                } else {
                    return false;
                }
            })
            break;
        case "btnDelete" : //删除
                DelDic();   
            break;
        case "btnClear" :
            clearform();
            break;
        case "btnQClear" :
            clearQform();
            //Querydic();
            break;  
        case "btnStop" : // 停用
            StopDic();
            break;
        default :
            break;
        }       
});
function CheckIndiCode(){
    if(getValueById("Code")==""){
        $.messager.popover({
            msg:'指标代码不能为空',
            type:'error'    
        });
        return false;   
    }   
    var rtn = tkMakeServerCall("BILL.DC.BL.IndicatorDefCtl","CheckUniqueCode",HospDr,getValueById('ActiveFlag'),getValueById("BusinessTypeCode"),getValueById("Code"));
    if((selRowid<1) && rtn.split("^"[0])>0){
        $.messager.popover({
            msg:'(业务类型+指标代码)重复了',
            type:'error'    
        });
        return false;       
    }
    return true;
} 
