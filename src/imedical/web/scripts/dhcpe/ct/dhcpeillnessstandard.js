
//����    dhcpe/ct/dhcpeillnessstandard.js
//����    ����ά��-��Ժ��
//����    2021-08-14
//������  yupeng
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
var tableName="DHC_PE_IllnessStandard";

$(function(){
	
    //��ȡ�����б�
    GetLocComp(SessionStr)
    
    InitCombobox();
    
    InitIllnessFindDataGrid();
   
    //��ѯ
    $("#BFind").click(function() {  
        BFind_click();      
        });
      
    //����
    $("#BClear").click(function() { 
        BClear_click();     
        });
        
    //����
    $('#add_btn').click(function(e){
        AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(){
        UpdateData();
    });
    
    //����ά��
     $('#Alias_btn').click(function(){
        Alias_Click();
    });
    
    //�����뽨�����
     $('#ILLED_btn').click(function(){
        ILLED_Click();
    });
    
    //��������Ŀ����
     $('#IllItem_btn').click(function(){
        IllItem_Click();
    });
    
    //��������
     $('#IllExplain_btn').click(function(){
        IllExplain_Click();
    });
    
    //�˶�ָ��
     $('#IllSportGuide_btn').click(function(){
        IllSportGuide_Click();
    });
    
   //��ʳָ��
    $('#IllDietGuide_btn').click(function(){
        IllDietGuide_Click();
    });
    
    //������Ȩ
	$("#BPower").click(function(){
    	BPower_click();
	})
    
	//��Ȩ����
	$("#BRelateLoc").click(function(){
   		BRelateLoc_click();
 	})
 	
   
    //���������б�change
	$("#LocList").combobox({
 	 	onSelect:function(){
	 	 	BFind_click()
	  	
  		}
	})  
	
	 // IllCondition_btn ����ָ��
  	$('#IllCondition_btn').click(function(){
    	IllCondition_Click();
    });
	
	
})
function IllCondition_Click(){
	
	//debugger; //
	var ID=$("#ILLSRowId").val();
	var Desc=$("#ILLSDesc").val();
	//alert(ID)
	//alert(Desc)
	lnk="dhcpeillnesscondition.hisui.csp"+"?ParrefRowId="+ID+"&Desc="+Desc;
					
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1280,height=600,hisui=true,title=����ָ��ά��-'+Desc);
	
}
function IllCondition_Click(){
	
	var ID=$("#ILLSRowId").val();
	var Desc=$("#ILLSDesc").val();
	//alert(ID)
	//alert(Desc)
	lnk="dhcpeillnesscondition.hisui.csp"+"?ParrefRowId="+ID+"&Desc="+Desc;
					
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1280,height=600,hisui=true,title=����ָ��ά��-'+Desc);
	
}

//������Ȩ/ȡ����Ȩ
function BPower_click(){
	var DateID=$("#ILLSRowId").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ������Ȩ�ļ�¼","info"); 
		return false;
	}
	var selected = $('#IllnessFindGrid').datagrid('getSelected');
	if(selected){
	
		//������Ȩ 
	    var iEmpower=$.trim($("#BPower").text());
	    if(iEmpower==$g("������Ȩ")){var iEmpower="Y";}
	    else if(iEmpower==$g("ȡ����Ȩ")){var iEmpower="N";}
		var LocID=$("#LocList").combobox('getValue');
		var UserID=session['LOGON.USERID'];
		//alert(tableName+"^"+DateID+"^"+LocID+"^"+UserID+"^"+iEmpower)
	    var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",tableName,DateID,LocID,UserID,iEmpower)
		var rtnArr=rtn.split("^");
		if(rtnArr[0]=="-1"){
			$.messager.alert("��ʾ","��Ȩʧ��","error");
		}else{
			$.messager.popover({msg:'��Ȩ�ɹ�',type:'success',timeout: 1000});
			 $("#IllnessFindGrid").datagrid('reload');
		}		
	}	
}
    
    
//���ݹ�������
function BRelateLoc_click()
{
    var DataID=$("#ILLSRowId").val()
    if (DataID==""){
        $.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
        return false;
    }
   
   var LocID=$("#LocList").combobox('getValue')
   
   OpenLocWin(tableName,DataID,SessionStr,LocID,InitIllnessFindDataGrid)

   
}
function LoadIllStandard()
{
     $("#IllnessFindGrid").datagrid('reload');
}
//��������
function IllExplain_Click(){
    ILLEDSave_Click("1");
}

//�˶�ָ��
function IllSportGuide_Click(){
    ILLEDSave_Click("2");
}

//��ʳָ��
function IllDietGuide_Click(){
    ILLEDSave_Click("3");
}

function ILLEDSave_Click(Type)
{
     var LocListID=$("#LocList").combobox('getValue');
     var record = $("#IllnessFindGrid").datagrid("getSelected"); 
    
     if (!(record)) {
                $.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
                return;
     } else {  
                var illDesc=record.ED_DiagnoseConclusion
                var illRowId=record.ED_RowId
                
                
                lnk="dhcpe.ct.illexplain.csp"+"?selectrow="+illRowId+"&selectrowDesc="+illDesc+"&Type="+Type+"&SelectLocID="+LocListID;
                var title="��������"
                if(Type==2) title="�˶�ָ��"
                if(Type==3) title="��ʳָ��"
                websys_lu(lnk,false,'iconCls=icon-w-edit,width=1050,height=600,hisui=true,title='+$g(title)+'-'+$g(illDesc));

            }  
}


function ILLEDSave_ClickBak(Type){
    var ID=$("#ILLSRowId").val();
    var Desc=$("#ILLSDesc").val();
    $("#ILLSName").val(Desc);
    if(ID==""){
        $.messager.alert('��ʾ','��ѡ���ά���ļ�¼',"info");
         return false;
    }
    if(Type=="1"){ 
        var title="��������-"+Desc;
        document.getElementById("TIllExplain").innerHTML=$g("��������");
    }
    if(Type=="2"){ 
        var title="�˶�ָ��-"+Desc;
        
        document.getElementById("TIllExplain").innerHTML=$g("�˶�ָ��");
    }
    if(Type=="3"){ 
        var title="��ʳָ��-"+Desc;
        document.getElementById("TIllExplain").innerHTML=$g("��ʳָ��");
    }
    
    
    var IllEStr=tkMakeServerCall("web.DHCPE.IllnessStandard","GetIllInfo",ID,Type);
           var ILLEList=IllEStr.split("@@");
           $("#IllExplain").val(ILLEList[0]);
           
           if(ILLEList[1]=="Y"){
                $("#PrintFlag").checkbox('setValue',true);
           }else{
               $("#PrintFlag").checkbox('setValue',false);
           }
          
           
    $("#IllExplainWin").show();
     
        var myWin = $HUI.dialog("#IllExplainWin",{
            iconCls:'icon-w-save',
            resizable:true,
            title:title,
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:$g('����'),
                id:'saveILLE_btn',
                handler:function(){
                    SaveILLEForm(ID,Type)
                }
            },{
                text:$g('�ر�'),
                handler:function(){
                    myWin.close();
                }
            }]
        });
        
}
SaveILLEForm=function(ID,Type)
{ 
    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
    
    var IllExplain=$("#IllExplain").val();
    var iPrintFlag="N"
    var PrintFlag=$("#PrintFlag").checkbox('getValue');
    if(PrintFlag) {iPrintFlag="Y";}
    
    var Instring=ID+"^"+IllExplain+"^"+Type+"^"+iPrintFlag;
    //alert(Instring)
    var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","SaveIllExplain",Instring);
     if(flag==0){
            $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
            $("#IllnessFindGrid").datagrid('load',{
               ClassName:"web.DHCPE.CT.IllnessStandard",
                QueryName:"QueryIll",
                Code:$("#Code").val(),
                DiagnoseConclusion:$("#DiagnoseConclusion").val(),
                Alias:$("#Alias").val(),
                NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
                tableName:tableName, 
                LocID:LocID
                }); 
            $('#IllExplainWin').dialog('close'); 
        }else{
            $.messager.alert('��ʾ',$g("����ʧ��")+":  "+flag,"error");
        }
        
    }
    
//�����뽨�����
function ILLED_Click(){
	   
	   var LocListID=$("#LocList").combobox('getValue');
        var record = $("#IllnessFindGrid").datagrid("getSelected"); 
    
            if (!(record)) {
                $.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
                return;
            } else {  
                var illDesc=record.ED_DiagnoseConclusion
                var illRowId=record.ED_RowId
                /*
                $("#myWinILLED").show();  
                var myWinGuideImage = $HUI.window("#myWinILLED",{
                    resizable:true,
                    collapsible:false,
                    minimizable:false,
                    iconCls:'icon-w-paper',
                    title:"�����뽨�����-"+illDesc,
                    modal:true,
                    content:'<iframe id="timeline" frameborder="0" src="dhcpeilledrelate.hisui.csp?selectrow='+illRowId+'&selectrowDesc='+illDesc+'" width="100%" height="99%" ></iframe>'
                }); 
                */
                lnk="dhcpe.ct.illedrelate.csp"+"?selectrow="+illRowId+"&selectrowDesc="+illDesc+"&SelectLocID="+LocListID;
                    
                websys_lu(lnk,false,'iconCls=icon-w-edit,width=1250,height=600,hisui=true,title='+$g('�����뽨�����')+'-'+$g(illDesc));

            }
}

//��������Ŀ����
function IllItem_Click(){

		var LocListID=$("#LocList").combobox('getValue');
        var record = $("#IllnessFindGrid").datagrid("getSelected"); 
    
            if (!(record)) {
                $.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
                return;
            } else {  
                var illDesc=record.ED_DiagnoseConclusion
                var illRowId=record.ED_RowId
                
                lnk="dhcpe.ct.illitem.csp"+"?selectrow="+illRowId+"&selectrowDesc="+illDesc+"&SelectLocID="+LocListID;
                    
                websys_lu(lnk,false,'iconCls=icon-w-edit,width=1320,height=600,hisui=true,title='+$g("��������Ŀ����")+'-'+$g(illDesc));

            }
}

    
//����ά��
function Alias_Click(){

    var LocListID=$("#LocList").combobox('getValue');
    var record = $("#IllnessFindGrid").datagrid("getSelected"); 
    
            if (!(record)) {
                $.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
                return;
            } else {  
                var illDesc=record.ED_DiagnoseConclusion
                var illRowId=record.ED_RowId
               
				$("#myWinAlias").show();  
                
                var lnk="dhcpeillsalias.hisui.csp?selectrow="+illRowId+"&selectrowDesc="+illDesc;
                
	            $HUI.window("#myWinAlias", {
                    collapsible: false,
        			minimizable: false,
       				 maximizable: false,
        			resizable: false,
       				closable: true,
                    iconCls:'icon-w-paper',
                    title:$g("����ά��-")+$g(illDesc),
                    modal:true,
                    width: 800,
        			height: 500,
                    content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
                    
                }); 
                
            }
}

//����
function AddData()
{
    
    $("#myWin").show();
     
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'����',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:$g('����'),
                id:'save_btn',
                handler:function(){
                    SaveForm("")
                }
            },{
                text:$g('�ر�'),
                handler:function(){
                    myWin.close();
                }
            }]
        });
        $('#form-save').form("clear");
        var MaxCode=tkMakeServerCall("web.DHCPE.IllnessStandard","GetMaxCode");
        $("#IllCode").val(MaxCode);
        //Ĭ��ѡ��
        //$HUI.checkbox("#CommonIllness").setValue(true);   
    
}

SaveForm=function(id)
{ 
    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
    var UserId=session['LOGON.USERID'];
    
    var Code=$("#IllCode").val();
     
     if (""==Code){
        $("#IllCode").focus();
    
         $.messager.alert('��ʾ','������Ų���Ϊ��',"info");
        return false
    } 
    
    var Illness="N";
    var iCommonIllness="N"
    var CommonIllness=$("#CommonIllness").checkbox('getValue');
    if(CommonIllness) {iCommonIllness="Y";}
    
    
    var DiagnoseConclusion=$("#IllDesc").val();
    if (""==DiagnoseConclusion){
        $("#IllDesc").focus();
        
        $.messager.alert('��ʾ','�������Ʋ���Ϊ��',"info");
        return false
    } 
    
    var InsertType=""
    
    var IllAlias=$("#IllAlias").val();
    
    
    var Detail=$("#IllDetail").val()
    if (""==Detail){
        
        $.messager.alert('��ʾ','�������鲻��Ϊ��',"info");
        return false
    } 
        
    var ToReport=0;
    var SexDR=$("#Sex").combobox('getValue');
    if (($('#Sex').combobox('getValue')==undefined)||($('#Sex').combobox('getValue')=="")){var SexDR="";}
    var Type=$("#Type").combobox('getValue');
    if (($('#Type').combobox('getValue')==undefined)||($('#Type').combobox('getValue')=="")){var Type="";}
    
    
    var iNoActive="N"
    var NoActive=$("#IllNoActive").checkbox('getValue');
    if (NoActive) {iNoActive="Y";}
    
    var TypeNew=$("#TypeNew").combobox('getValue');
	if (($('#TypeNew').combobox('getValue')==undefined)||($('#TypeNew').combobox('getValue')=="")){var TypeNew="";}
	
	var ILLSStation=$("#ILLSStation").combobox('getValue');
	if (($('#ILLSStation').combobox('getValue')==undefined)||($('#ILLSStation').combobox('getValue')=="")){var ILLSStation="";}
	
	var FatherIll=$("#FatherIll").combobox('getValue');
	if (($('#FatherIll').combobox('getValue')==undefined)||($('#FatherIll').combobox('getValue')=="")){var FatherIll="";}
	
	var note=$("#IllNote").val();	
    
    var iIfCompare="N"
  	var CommonIllness=$("#IfCompare").checkbox('getValue');
	if(CommonIllness) {iIfCompare="Y";}
    
	var ExsistFlag=tkMakeServerCall("web.DHCPE.CT.IllnessStandard","IsExsistILL",DiagnoseConclusion,LocID,id)
    if(ExsistFlag=="1"){
	    $.messager.alert('��ʾ',"��������:"+$g(DiagnoseConclusion)+"   �Ѵ��ڣ�","error");
	    return false;
    }
    var Instring=id+"^"+Code+"^"+DiagnoseConclusion+"^"+Detail+"^"+Illness+"^"+iCommonIllness+"^"+UserId+"^"+InsertType+"^"+IllAlias+"^"+ToReport+"^"+SexDR+"^"+Type+"^"+iNoActive+"^"+TypeNew+"^"+ILLSStation+"^"+FatherIll+"^"+note+"^"+iIfCompare;
    
    
    var ReturnStr=tkMakeServerCall("web.DHCPE.CT.IllnessStandard","UpdateIll",Instring,LocID);
    var flag=ReturnStr.split("^")[0];
    if(flag==0){
            $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
            $("#IllnessFindGrid").datagrid('load',{
               ClassName:"web.DHCPE.CT.IllnessStandard",
                QueryName:"QueryIll",
                Code:$("#Code").val(),
                DiagnoseConclusion:$("#DiagnoseConclusion").val(),
                Alias:$("#Alias").val(),
                NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
                tableName:tableName, 
                LocID:LocID
                }); 
            $('#myWin').dialog('close'); 
        }else{
            $.messager.alert('��ʾ',"����ʧ��"+ReturnStr,"error");
        }
        
    }
    
function UpdateData()
{
    var ID=$("#ILLSRowId").val();
    if(ID==""){
        $.messager.alert('��ʾ',"��ѡ����޸ĵļ�¼","info");
        return
    }
    if(ID!="")
    {   
          var EDStr=tkMakeServerCall("web.DHCPE.IllnessStandard","InitED",ID);
           var EDList=EDStr.split("^");
           $("#IllCode").val(EDList[0]);
           $("#IllDesc").val(EDList[1]);
           $("#IllDetail").val(EDList[2]);
			debugger; //
		    $("#TypeNew").combobox('setValue',EDList[14]);
		   $("#ILLSStation").combobox('setValue',EDList[15]);
		   $("#FatherIll").combobox('setValue',EDList[16]);
		   $("#IllNote").val(EDList[17]);
		 
		 
           if(EDList[6]=="Y"){
                $("#CommonIllness").checkbox('setValue',true);
           }else{
               $("#CommonIllness").checkbox('setValue',false);
           }
           $("#Sex").combobox('setValue',EDList[8]);
           $("#Type").combobox('setValue',EDList[10]);
           if(EDList[11]=="N"){
	            $("#IllNoActive").checkbox('setValue',false);
               
           }else{
	            $("#IllNoActive").checkbox('setValue',true);
              
           }
            $("#TypeNew").combobox('setValue',EDList[14]);
		   $("#ILLSStation").combobox('setValue',EDList[15]);
		   $("#FatherIll").combobox('setValue',EDList[16]);
		   $("#IllNote").val(EDList[17]);
		  // alert(EDList[15])
		   if(EDList[18]=="Y"){
			    $("#IfCompare").checkbox('setValue',true);
		   }else{
			   
			   $("#IfCompare").checkbox('setValue',false);
		   }
          

            $("#myWin").show();
            
            var myWin = $HUI.dialog("#myWin",{
                iconCls:'icon-w-edit',
                resizable:true,
                title:'�޸�',
                modal:true,
                buttons:[{
                    text:$g('����'),
                    id:'save_btn',
                    handler:function(){
                        SaveForm(ID)
                    }
                },{
                    text:$g('�ر�'),
                    handler:function(){
                        myWin.close();
                    }
                }]
            });                         
    }
}

//��ѯ
function BFind_click(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
		
    $("#IllnessFindGrid").datagrid('clearSelections');
    $("#IllnessFindGrid").datagrid('load',{
            ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"QueryIll",
            Code:$("#Code").val(),
            DiagnoseConclusion:$("#DiagnoseConclusion").val(),
            Alias:$("#Alias").val(),
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:LocID
        }); 
        
        $("#ILLSRowId").val("");
        $("#ILLSDesc").val("");


}

//����
function BClear_click(){
    $("#Code,#DiagnoseConclusion,#Alias").val("");
	$("#NoActive").checkbox("setValue",true);
    BFind_click();
}


function InitIllnessFindDataGrid(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
		
    $HUI.datagrid("#IllnessFindGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 20,
        pageList : [20,100,200],
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"QueryIll",
            Code:$("#Code").val(),
            DiagnoseConclusion:$("#DiagnoseConclusion").val(),
            Alias:$("#Alias").val(),
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:LocID
            
        },
        frozenColumns:[[
            {field:'ED_Code',width:'100',title:'���'},
            {field:'ED_DiagnoseConclusion',width:'150',title:'��������'},
        ]],
        columns:[[
            {field:'ED_RowId',title:'ID',hidden: true},
            {field:'ED_CommonIllness',width:80,title:'������'},
            {field:'TSex',width:80,title:'�Ա�'},
            {field:'NoActive',width:80,title:'����',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
            },
       		{field:'Empower',width:90,title:'������Ȩ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			
			},
			{ field:'TEffPowerFlag',width:100,align:'center',title:'��ǰ������Ȩ',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			},
            {field:'TType',width:100,title:'����'},
            {field:'AliasDesc',width:120,title:'����'},
            {field:'ED_Detail',width:650,title:'����'},
			
            
        ]],
        onSelect: function (rowIndex, rowData) {
               
                $("#ILLSRowId").val(rowData.ED_RowId);
                $("#ILLSDesc").val(rowData.ED_DiagnoseConclusion);
                if(rowData.Empower=="Y"){	
				$("#BRelateLoc").linkbutton('enable');
				$("#BPower").linkbutton({text:$g('ȡ����Ȩ')});
			}else{
					$("#BRelateLoc").linkbutton('disable');
					$("#BPower").linkbutton('enable');
					$("#BPower").linkbutton({text:$g('������Ȩ')})
				
			}	
                
                    
        }
        
            
    })
}


function InitCombobox(){
    //�Ա�
    var SexObj = $HUI.combobox("#Sex",{
        valueField:'id',
        textField:'text',
        panelHeight:'100',
        data:[
            {id:'M',text:$g('��')},
            {id:'F',text:$g('Ů')},
            {id:'N',text:$g('����')},
           
        ]

        });
        
    //����
    var TypeObj = $HUI.combobox("#Type",{
        valueField:'id',
        textField:'text',
        panelHeight:'100',
        data:[
            {id:'1',text:$g('���屨��')},
            {id:'2',text:$g('����ͳ��')},
            {id:'3',text:$g('����ͳ��')},
            
        ]

        });
        
    // ���
	var SexObj = $HUI.combobox("#TypeNew",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'1',text:'����'},
            {id:'2',text:'����'},
            {id:'3',text:'��Ŀ'},
           
        ]

		});
		
	// վ��
	var SexObj = $HUI.combobox("#ILLSStation",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'

		});
	// �������
	var SexObj = $HUI.combobox("#FatherIll",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindIllness&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc'

		});
	
}

