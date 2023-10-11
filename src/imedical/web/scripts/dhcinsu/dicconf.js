<!--js dicconf.js-->
/*
 * ҽ��ϵͳ���ã�����ʹ�ã�-�°�
 * FileName: dicconf.js
 * tanfb 2022-12-02
 */

var ChoDicCode="";
var TreeSehKey="";
var ChooTreeID=0; //ѡ��tree��id��Ϊ��ˢ��tree���ٴ�Ĭ��ѡ��֮ǰѡ��
var searchDicListKey="";

var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
var PassWardFlag = "N";


$(function() {
    setPageLayout();
});
function setPageLayout() {
    
    //��ʼ��ҽԺ������
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
    
    //��ʼ����Ȩ��־������
    $HUI.combobox("#autFlag",{
        valueField:'cCode',
        textField:'cCode',
        panelHeight:100
    });
    
    //��ʼ����״�ṹ
    iniTreeGrid();
    loadDicTree();
    
    // ͬ��ˢ�¿���
    $HUI.checkbox('#checkbox1',{
        onChecked:function(event,val){
            var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",""); //��������Ժ��Ϊ��
            loadDicTree()
        },
        onUnchecked:function(event,val){
            var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",PUBLIC_CONSTANT.SESSION.HOSPID);
            loadDicTree()
        },      

    })
    
    //��ʼ��datagrid
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
            {field:'cType',title:'�ֵ����',width:80},
            {field:'cCode',title:'����',width:90},
            {field:'cDesc',title:'����',width:150},
            {field:'cBill1',title:'ҽ������',width:80},
            {field:'cBill2',title:'ҽ������',width:150},
            //{field:'cDemo',title:'��ע',width:150,align:'center',showTip:true},
            {field:'cDemo',title:'��ע',width:150,showTip:true},
            {field:'DicAuthorityFlag',title:'��Ȩ��־',width:80},
            {field:'DicOPIPFlag',title:'����סԺ��־',width:110},
            {field:'selected',title:'Ĭ��ʹ�ñ�־',width:110,formatter:function(val,index,rowdData){
                if(val){
                    return "Y"  
                }else{
                    return "N"  
                }
            }},
            {field:'DicUseFlag',title:'ʹ�ñ�־',width:80},
            {field:'DicRelationFlag',title:'���������ֵ��־',width:110},
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
    
    //�ֵ�����������
    $("#searchTree").searchbox({
        searcher: function(value) {
            TreeSehKey=value;
            loadDicTree(value);
        }
    });
    
    //�ֵ���ϸ������
    $("#searchDicList").searchbox({
        searcher: function(value) {
            searchDicListKey=value;
            Querydic(ChoDicCode,value);
        }
    });

}

//��ʼ����״�ṹ
function iniTreeGrid(){
    $HUI.tree("#SYSTree", {
        lines:true,
        animate: true,
        onBeforeCollapse:function(node){//�ڵ��۵�ǰ���������� false ��ȡ���۵�������
            //if(node.type==0){
               return false;//�����۵�
            //}
        },
        onLoadSuccess: function(data) {
                $("#SYSTree li:eq("+ChooTreeID+")").find("div").addClass("tree-node-selected");   //����һ���ڵ����  
                var n = $("#SYSTree").tree("getSelected");  
                if(n!=null){  
                $("#SYSTree").tree("select",n.target);    //�൱��Ĭ�ϵ����һ�½ڵ㣬ִ��onSelect����  
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
                objData.TreeFlo='0';//����
                objData.children=[];
                objData.attributes=jsonData.rows[i];
                CharData.push(objData);
                ChildNum=ChildNum+1;
                
            }
            else
            {
                objData.id=i+1;
                objData.TreeFlo='1';//�Ӽ�
                objData.text=jsonData.rows[i].INDIDDicDesc//+"("+jsonData.rows[i].DicNum+")";
                objData.attributes=jsonData.rows[i];
                //objData.state='closed';
                CharData[ChildNum-1]['children'].push(objData);
            }
        }
        //tree��ֵ
        $('#SYSTree').tree({ data: CharData });
    });
    
    
    //��Ȩ��־
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

//���±����¼
function UpdateDic(){
    /*
    if($('#code')[0].isDisabled){
        $.messager.alert('��ʾ','δ�޸�!');   
        return;
    }
    */
    
    //�����ַ�^�Ĵ���
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
        $.messager.alert('��ʾ',"��ѡ����ȷ����Ȩ��ʶ",'info')
        return;
    }
    
    if ((""!=tautFlag)&&(seldictype!="SYS"))
    {
        $.messager.alert('��ʾ',"��ϵͳ(SYS)�ڵ����ֵ�����,����ѡ����Ȩ��ʶ",'info')
        return ;
    }
    
    
        
    if($('#code').val().indexOf("������")>=0 || $('#code').val()==""){$.messager.alert('��ʾ','��������Ϣ���ٱ���!','info');return;}
    if($('#desc').val().indexOf("������")>=0 || $('#desc').val()==""){$.messager.alert('��ʾ','���Ʋ���Ϊ��!','info');return;}
    if((seldictype=="")||(seldictype=='undefined')){
        $.messager.alert('��ʾ','��ѡ���ֵ����!','info');return;
    }
    
    var saveinfo=selRowid+"^"+seldictype+"^"+$('#code').val()+"^"+$('#desc').val()+"^"+$('#insucode').val()+"^"+$('#insudesc').val()+"^"+$('#note').val();
    saveinfo=saveinfo+"^"+$HUI.combobox('#autFlag').getValue()+"^"+$('#opIPFlag').val()+"^"+$('#defUserFlag').val()+"^"+$('#userFlag').val()+"^"+$('#relUserFlag').val()+"^^^";
    saveinfo=saveinfo.replace(/��������Ϣ/g,"")
    ///alert(saveinfo)
    var savecode=tkMakeServerCall("web.INSUDicDataCom","Update","","",saveinfo)
    //alert(savecode)
    if(eval(savecode)>0){
        //$.messager.alert('��ʾ','����ɹ�!');  
        $("#DicList").datagrid('reload')
        $("#DicList").datagrid('unselectAll')
        clearform("")
        $.messager.alert('��ʾ','����ɹ�!','info');   
    }else{
        if(eval(savecode)==-1001){
            $.messager.alert('��ʾ','��'+$('#code').val()+'���˴����Ѵ�����ͬ��¼!���Ҫ�����������Ȳ�ѯ���˴���ļ�¼!','info');  
            return; 
        }
        $.messager.alert('��ʾ','����ʧ��!','info');   
    }
}
//ɾ����¼
function DelDic(){
    //if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('��ʾ','����Ȩ��,����ϵ����Ա��Ȩ!');return;}
    if(selRowid=="" || selRowid<0 || !selRowid){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!','info');return;}
    $.messager.confirm('��ȷ��','��ȷ��Ҫɾ��������¼��?',function(fb){
        if(fb){
            var savecode=tkMakeServerCall("web.INSUDicDataCom","Delete","","",selRowid)
            if(eval(savecode)>0){
                $.messager.alert('��ʾ','ɾ���ɹ�!','info');   
                $("#DicList").datagrid('reload')
                selRowid="";
                $("#DicList").datagrid("getPager").pagination('refresh');
                $("#DicList").datagrid('unselectAll')
            }else{
                $.messager.alert('��ʾ','ɾ��ʧ��!','info');   
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
        if(okSpanHtml=="Cancel"|| okSpanHtml=="ȡ��"){
            $okSpan.parent().parent().trigger("focus");
        }
    }

}

//����±ߵ�form
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
//����±ߵ�form
function clearform(inArgs){
    
    $('#editinfo input').each(function(){        
        $(this).val(inArgs)
    })
    selRowid="";
}

//��ѯ�ֵ�����
function Querydic(Type,dicKey){
    $('#DicList').datagrid('loadData',{total:0,rows:[]});
    // tangzf 2020-6-17 ʹ��HISUI�ӿ� ��������
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

//�����ַ�����
function SplVCFormat(FStr)
{
    return  FStr.replace(/\^/g,"");
}

//�ı��±���ʾ��ı༭״̬
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
        case "btnUpdate" : // ����
            if(PassWardFlag == "N"){
                $.messager.prompt("��ʾ", "����������", function (r) { // prompt �˴���Ҫ����Ϊ��������
                    if (r) {
                        PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
                        if(PassWardFlag=='Y') UpdateDic(); 
                        else{
                            $.messager.alert('����','�������','error');  
                        }
                    } else {
                        return false;
                    }
                })
            }else{
                UpdateDic(); 
            }
            break;
        case "btnDelete" : //ɾ��
            if(PassWardFlag == "N"){
                $.messager.prompt("��ʾ", "����������", function (r) { // prompt �˴���Ҫ����Ϊ��������
                    if (r) {
                        PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
                        if(PassWardFlag=='Y') DelDic(); 
                        else{
                            $.messager.alert('����','�������','error');  
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
