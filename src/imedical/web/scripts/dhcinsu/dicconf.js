<!--js dicconf.js-->
/*
 * 医保系统配置（开发使用）-新版
 * FileName: dicconf.js
 * tanfb 2022-12-02
 */

var ChoDicCode="";
var TreeSehKey="";
var ChooTreeID=0; //选中tree的id，为了刷新tree后再次默认选中之前选的
var searchDicListKey="";

var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
var PassWardFlag = "N";


$(function() {
    setPageLayout();
});
function setPageLayout() {
    
    //初始化医院下拉框
    var tableName = "User.INSUTarContrast";
    var defHospId = 2;//
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
            //loadDicTree(TreeSehKey);
        }
    });
    
    //初始化授权标志下拉框
    $HUI.combobox("#autFlag",{
        valueField:'cCode',
        textField:'cCode',
        panelHeight:100
    });
    
    //初始化树状结构
    iniTreeGrid();
    loadDicTree();
    
    // 同步刷新开关
    $HUI.checkbox('#checkbox1',{
        onChecked:function(event,val){
            var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",""); //公有数据院区为空
            loadDicTree()
        },
        onUnchecked:function(event,val){
            var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",PUBLIC_CONSTANT.SESSION.HOSPID);
            loadDicTree()
        },      

    })
    
    //初始化datagrid
    $HUI.datagrid("#DicList",{
        data:[],
        fit: true,
        rownumbers:true,
        width: '100%',
        border:false,
        striped:true,
        fitColumns:false,
        singleSelect: true,
        autoRowHeight:false,
        columns:[[
            {field:'cType',title:'字典类别',width:80},
            {field:'cCode',title:'代码',width:90},
            {field:'cDesc',title:'名称',width:150},
            {field:'cBill1',title:'医保代码',width:80},
            {field:'cBill2',title:'医保描述',width:150},
            //{field:'cDemo',title:'备注',width:150,align:'center',showTip:true},
            {field:'cDemo',title:'备注',width:150,showTip:true},
            {field:'DicAuthorityFlag',title:'授权标志',width:80},
            {field:'DicOPIPFlag',title:'门诊住院标志',width:110},
            {field:'selected',title:'默认使用标志',width:110,formatter:function(val,index,rowdData){
                if(val){
                    return "Y"  
                }else{
                    return "N"  
                }
            }},
            {field:'DicUseFlag',title:'使用标志',width:80},
            {field:'DicRelationFlag',title:'关联其他字典标志',width:110},
            {field:'id',title:'id',width:10,hidden:true}
        ]],
        pageSize: 30,
        pagination:true,
        onClickRow : function(rowIndex, rowData) {
            
            if(tmpselRow==rowIndex){
                clearform("")
                tmpselRow=-1
                $(this).datagrid('unselectRow',rowIndex)
            }else{
                fillform(rowIndex,rowData)
                tmpselRow=rowIndex
            }
            
        },

    }); 
    
    //字典类型搜索框
    $("#searchTree").searchbox({
        searcher: function(value) {
            TreeSehKey=value;
            loadDicTree(value);
        }
    });
    
    //字典明细搜索框
    $("#searchDicList").searchbox({
        searcher: function(value) {
            searchDicListKey=value;
            Querydic(ChoDicCode,value);
        }
    });

}

//初始化树状结构
function iniTreeGrid(){
    $HUI.tree("#SYSTree", {
        lines:true,
        animate: true,
        onBeforeCollapse:function(node){//节点折叠前触发，返回 false 则取消折叠动作。
            //if(node.type==0){
               return false;//不让折叠
            //}
        },
        onLoadSuccess: function(data) {
                $("#SYSTree li:eq("+ChooTreeID+")").find("div").addClass("tree-node-selected");   //设置一个节点高亮  
                var n = $("#SYSTree").tree("getSelected");  
                if(n!=null){  
                $("#SYSTree").tree("select",n.target);    //相当于默认点击了一下节点，执行onSelect方法  
           } 
        },
        onClick: function (data) {
            //$(this).tree("toggle", data.target);
        },
        onSelect: function(data) { 
            if(data.attributes.INDIDDicCode=="SYS"){
                clearform("");
                return false;    
            }         
            clearform();
            ChooTreeID=data.id-1;
            ChoDicCode=data.attributes.INDIDDicCode;
            Querydic(data.attributes.INDIDDicCode);
            
        },
        onLoadError:function(a){
            //alert(2)
        }
    });
}
function loadDicTree(TreeKey){

    
    
    var PublicDatacheckbox = $('#checkbox1').checkbox('getValue');
    if( !PublicDatacheckbox ){
        var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",PUBLIC_CONSTANT.SESSION.HOSPID);   
    }
    $.cm({
        ClassName:"web.INSUDicDataCom",
        QueryName:"QueryDicSys",
        CodeAndDesc:TreeKey,
        queryFlag:"",
        rows:1000
    },function(jsonData){   
        var CharData=[];
        var ChildNum=0;
        for (i=0;i<jsonData.rows.length;i++) 
        {
            var objData={};
            if(jsonData.rows[i].INDIDDicCode == "SYS"){
                objData.id=i+1;
                objData.text=jsonData.rows[i].INDIDDicDesc//+"("+jsonData.rows[i].DicNum+")";
                objData.state='open';//closed
                objData.TreeFlo='0';//父级
                objData.children=[];
                objData.attributes=jsonData.rows[i];
                CharData.push(objData);
                ChildNum=ChildNum+1;
                
            }
            else
            {
                objData.id=i+1;
                objData.TreeFlo='1';//子级
                objData.text=jsonData.rows[i].INDIDDicDesc//+"("+jsonData.rows[i].DicNum+")";
                objData.attributes=jsonData.rows[i];
                //objData.state='closed';
                CharData[ChildNum-1]['children'].push(objData);
            }
        }
        //tree赋值
        $('#SYSTree').tree({ data: CharData });
    });
    
    
    //授权标志
    var comboJson=$.cm({
        ClassName:"web.INSUDicDataCom",
        QueryName:"QueryDic",
        Type:"InsuDicAuthorityFlag",
        Code:""
     },false)
     
     setTimeout(function(){
        $HUI.combobox("#autFlag").loadData(comboJson.rows); 
    },100)
    
}

//更新保存记录
function UpdateDic(){
    /*
    if($('#code')[0].isDisabled){
        $.messager.alert('提示','未修改!');   
        return;
    }
    */
    
    //特殊字符^的处理
    /*$('#code').val($('#code').val().replace(/\^/g,""));
    $('#desc').val($('#desc').val().replace(/\^/g,""));
    $('#insucode').val($('#insucode').val().replace(/\^/g,""));
    $('#insudesc').val($('#insudesc').val().replace(/\^/g,""));
    $('#note').val($('#note').val().replace(/\^/g,""));
    $('#defUserFlag').val($('#defUserFlag').val().replace(/\^/g,""));
    $('#opIPFlag').val($('#opIPFlag').val().replace(/\^/g,""));
    $('#userFlag').val($('#userFlag').val().replace(/\^/g,""));
    $('#relUserFlag').val($('#relUserFlag').val().replace(/\^/g,""));
    $('#insucode').val($('#insucode').val().replace(/\^/g,""));
    $('#insudesc').val($('#insudesc').val().replace(/\^/g,""));
    $('#note').val($('#note').val().replace(/\^/g,""));
    */
    $('#code').val(SplVCFormat($('#code').val()));
    $('#desc').val(SplVCFormat($('#desc').val()));
    $('#insucode').val(SplVCFormat($('#insucode').val()));
    $('#insudesc').val(SplVCFormat($('#insudesc').val()));
    $('#note').val(SplVCFormat($('#note').val()));
    $('#defUserFlag').val(SplVCFormat($('#defUserFlag').val()));
    $('#opIPFlag').val(SplVCFormat($('#opIPFlag').val()));
    $('#userFlag').val(SplVCFormat($('#userFlag').val()));
    $('#relUserFlag').val(SplVCFormat($('#relUserFlag').val()));
    $('#insucode').val(SplVCFormat($('#insucode').val()));
    $('#insudesc').val(SplVCFormat($('#insudesc').val()));
    $('#note').val(SplVCFormat($('#note').val()));
    
    //20190102 DingSH
    var tautFlag=$HUI.combobox('#autFlag').getValue();
    if (undefined==tautFlag)
    {
        $.messager.alert('提示',"请选择正确的授权标识",'info')
        return;
    }
    
    if ((""!=tautFlag)&&(seldictype!="SYS"))
    {
        $.messager.alert('提示',"非系统(SYS)节点下字典类型,不能选择授权标识",'info')
        return ;
    }
    
    
        
    if($('#code').val().indexOf("请输入")>=0 || $('#code').val()==""){$.messager.alert('提示','请输入信息后再保存!','info');return;}
    if($('#desc').val().indexOf("请输入")>=0 || $('#desc').val()==""){$.messager.alert('提示','名称不能为空!','info');return;}
    if((seldictype=="")||(seldictype=='undefined')){
        $.messager.alert('提示','请选择字典类别!','info');return;
    }
    
    var saveinfo=selRowid+"^"+seldictype+"^"+$('#code').val()+"^"+$('#desc').val()+"^"+$('#insucode').val()+"^"+$('#insudesc').val()+"^"+$('#note').val();
    saveinfo=saveinfo+"^"+$HUI.combobox('#autFlag').getValue()+"^"+$('#opIPFlag').val()+"^"+$('#defUserFlag').val()+"^"+$('#userFlag').val()+"^"+$('#relUserFlag').val()+"^^^";
    saveinfo=saveinfo.replace(/请输入信息/g,"")
    ///alert(saveinfo)
    var savecode=tkMakeServerCall("web.INSUDicDataCom","Update","","",saveinfo)
    //alert(savecode)
    if(eval(savecode)>0){
        //$.messager.alert('提示','保存成功!');  
        $("#DicList").datagrid('reload')
        $("#DicList").datagrid('unselectAll')
        clearform("")
        $.messager.alert('提示','保存成功!','info');   
    }else{
        if(eval(savecode)==-1001){
            $.messager.alert('提示','【'+$('#code').val()+'】此代码已存在相同记录!如果要更新内容请先查询出此代码的记录!','info');  
            return; 
        }
        $.messager.alert('提示','保存失败!','info');   
    }
}
//删除记录
function DelDic(){
    //if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
    if(selRowid=="" || selRowid<0 || !selRowid){$.messager.alert('提示','请选择要删除的记录!','info');return;}
    $.messager.confirm('请确认','你确认要删除这条记录吗?',function(fb){
        if(fb){
            var savecode=tkMakeServerCall("web.INSUDicDataCom","Delete","","",selRowid)
            if(eval(savecode)>0){
                $.messager.alert('提示','删除成功!','info');   
                $("#DicList").datagrid('reload')
                selRowid="";
                $("#DicList").datagrid("getPager").pagination('refresh');
                $("#DicList").datagrid('unselectAll')
            }else{
                $.messager.alert('提示','删除失败!','info');   
            }
        }else{
            return; 
        }
    });
    
    var okSpans=$(".l-btn-text");
    var len=okSpans.length;
    for(var i=0;i<len;i++){
        var $okSpan=$(okSpans[i]);
        var okSpanHtml=$okSpan.html();
        if(okSpanHtml=="Cancel"|| okSpanHtml=="取消"){
            $okSpan.parent().parent().trigger("focus");
        }
    }

}

//填充下边的form
function fillform(rowIndex,rowData){
    // cType,cCode,cDesc,cDemo,cBill1,cBill2,selected:%Boolean,DicAuthorityFlag,DicOPIPFlag,DicUseFlag,DicRelationFlag,DicBill3,DicBill4,DicBill5
    selRowid=rowData.id
    //disinput(true);
    $('#code').val(rowData.cCode);
    $('#insucode').val(rowData.cBill1);
    $('#desc').val(rowData.cDesc);
    $('#insudesc').val(rowData.cBill2);
    $('#note').val(rowData.cDemo);
    
    $HUI.combobox('#autFlag').setValue(rowData.DicAuthorityFlag);
    //alert(rowData.selected)
    $('#defUserFlag').val(rowData.selected==true?"Y":"N");
    $('#opIPFlag').val(rowData.DicOPIPFlag);
    $('#userFlag').val(rowData.DicUseFlag);
    $('#relUserFlag').val(rowData.DicRelationFlag);
}
//清除下边的form
function clearform(inArgs){
    
    $('#editinfo input').each(function(){        
        $(this).val(inArgs)
    })
    selRowid="";
}

//查询字典数据
function Querydic(Type,dicKey){
    $('#DicList').datagrid('loadData',{total:0,rows:[]});
    // tangzf 2020-6-17 使用HISUI接口 加载数据
    var QueryParam={
        ClassName:'web.INSUDicDataCom' ,
        QueryName: 'QueryDicByTypeOrCodeDesc',
        Type : Type, 
        dicKey :dicKey, 
        HospDr : $('#checkbox1').checkbox('getValue') ? "" : PUBLIC_CONSTANT.SESSION.HOSPID
    }
    seldictype=Type;
    loadDataGridStore('DicList',QueryParam);
    
}

//特殊字符处理
function SplVCFormat(FStr)
{
    return  FStr.replace(/\^/g,"");
}

//改变下边显示框的编辑状态
function disinput(tf){
    //return;
    $('#code').attr("disabled",tf);
    $('#insucode').attr("disabled",tf);
    $('#desc').attr("disabled",tf);
    $('#insudesc').attr("disabled",tf);
    $('#note').attr("disabled",tf);
    $('#note2').attr("disabled",tf);
    
    $('#autFlag').attr("disabled",tf);
    $('#defUserFlag').attr("disabled",tf);
    $('#opIPFlag').attr("disabled",tf);
    $('#userFlag').attr("disabled",tf);
    $('#relUserFlag').attr("disabled",tf);

}

$('.hisui-linkbutton').bind('click',function(){
     switch (this.id){ 
        case "btnUpdate" : // 保存
            if(PassWardFlag == "N"){
                $.messager.prompt("提示", "请输入密码", function (r) { // prompt 此处需要考虑为非阻塞的
                    if (r) {
                        PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
                        if(PassWardFlag=='Y') UpdateDic(); 
                        else{
                            $.messager.alert('错误','密码错误','error');  
                        }
                    } else {
                        return false;
                    }
                })
            }else{
                UpdateDic(); 
            }
            break;
        case "btnDelete" : //删除
            if(PassWardFlag == "N"){
                $.messager.prompt("提示", "请输入密码", function (r) { // prompt 此处需要考虑为非阻塞的
                    if (r) {
                        PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
                        if(PassWardFlag=='Y') DelDic(); 
                        else{
                            $.messager.alert('错误','密码错误','error');  
                        }
                    } else {
                        return false;
                    }
                })
            }else{
                DelDic(); 
            }
            break;
        case "btnClear" :
            clearform();
            break;  
        default :
            break;
        }
        
}) 
