
//名称    dhcpe/ct/dhcpeillnessstandard.js
//功能    疾病维护-多院区
//创建    2021-08-14
//创建人  yupeng
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
var tableName="DHC_PE_IllnessStandard";

$(function(){
	
    //获取下拉列表
    GetLocComp(SessionStr)
    
    InitCombobox();
    
    InitIllnessFindDataGrid();
   
    //查询
    $("#BFind").click(function() {  
        BFind_click();      
        });
      
    //清屏
    $("#BClear").click(function() { 
        BClear_click();     
        });
        
    //新增
    $('#add_btn').click(function(e){
        AddData();
    });
    
    //修改
    $('#update_btn').click(function(){
        UpdateData();
    });
    
    //别名维护
     $('#Alias_btn').click(function(){
        Alias_Click();
    });
    
    //疾病与建议对照
     $('#ILLED_btn').click(function(){
        ILLED_Click();
    });
    
    //疾病与项目对照
     $('#IllItem_btn').click(function(){
        IllItem_Click();
    });
    
    //疾病解释
     $('#IllExplain_btn').click(function(){
        IllExplain_Click();
    });
    
    //运动指导
     $('#IllSportGuide_btn').click(function(){
        IllSportGuide_Click();
    });
    
   //饮食指导
    $('#IllDietGuide_btn').click(function(){
        IllDietGuide_Click();
    });
    
    //单独授权
	$("#BPower").click(function(){
    	BPower_click();
	})
    
	//授权科室
	$("#BRelateLoc").click(function(){
   		BRelateLoc_click();
 	})
 	
   
    //科室下拉列表change
	$("#LocList").combobox({
 	 	onSelect:function(){
	 	 	BFind_click()
	  	
  		}
	})  
	
	 // IllCondition_btn 条件指标
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
					
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1280,height=600,hisui=true,title=疾病指标维护-'+Desc);
	
}
function IllCondition_Click(){
	
	var ID=$("#ILLSRowId").val();
	var Desc=$("#ILLSDesc").val();
	//alert(ID)
	//alert(Desc)
	lnk="dhcpeillnesscondition.hisui.csp"+"?ParrefRowId="+ID+"&Desc="+Desc;
					
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1280,height=600,hisui=true,title=疾病指标维护-'+Desc);
	
}

//单独授权/取消授权
function BPower_click(){
	var DateID=$("#ILLSRowId").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要单独授权的记录","info"); 
		return false;
	}
	var selected = $('#IllnessFindGrid').datagrid('getSelected');
	if(selected){
	
		//单独授权 
	    var iEmpower=$.trim($("#BPower").text());
	    if(iEmpower==$g("单独授权")){var iEmpower="Y";}
	    else if(iEmpower==$g("取消授权")){var iEmpower="N";}
		var LocID=$("#LocList").combobox('getValue');
		var UserID=session['LOGON.USERID'];
		//alert(tableName+"^"+DateID+"^"+LocID+"^"+UserID+"^"+iEmpower)
	    var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",tableName,DateID,LocID,UserID,iEmpower)
		var rtnArr=rtn.split("^");
		if(rtnArr[0]=="-1"){
			$.messager.alert("提示","授权失败","error");
		}else{
			$.messager.popover({msg:'授权成功',type:'success',timeout: 1000});
			 $("#IllnessFindGrid").datagrid('reload');
		}		
	}	
}
    
    
//数据关联科室
function BRelateLoc_click()
{
    var DataID=$("#ILLSRowId").val()
    if (DataID==""){
        $.messager.alert("提示","请选择需要授权的记录","info"); 
        return false;
    }
   
   var LocID=$("#LocList").combobox('getValue')
   
   OpenLocWin(tableName,DataID,SessionStr,LocID,InitIllnessFindDataGrid)

   
}
function LoadIllStandard()
{
     $("#IllnessFindGrid").datagrid('reload');
}
//疾病解释
function IllExplain_Click(){
    ILLEDSave_Click("1");
}

//运动指导
function IllSportGuide_Click(){
    ILLEDSave_Click("2");
}

//饮食指导
function IllDietGuide_Click(){
    ILLEDSave_Click("3");
}

function ILLEDSave_Click(Type)
{
     var LocListID=$("#LocList").combobox('getValue');
     var record = $("#IllnessFindGrid").datagrid("getSelected"); 
    
     if (!(record)) {
                $.messager.alert('提示','请选择待维护的记录!',"warning");
                return;
     } else {  
                var illDesc=record.ED_DiagnoseConclusion
                var illRowId=record.ED_RowId
                
                
                lnk="dhcpe.ct.illexplain.csp"+"?selectrow="+illRowId+"&selectrowDesc="+illDesc+"&Type="+Type+"&SelectLocID="+LocListID;
                var title="疾病解释"
                if(Type==2) title="运动指导"
                if(Type==3) title="饮食指导"
                websys_lu(lnk,false,'iconCls=icon-w-edit,width=1050,height=600,hisui=true,title='+$g(title)+'-'+$g(illDesc));

            }  
}


function ILLEDSave_ClickBak(Type){
    var ID=$("#ILLSRowId").val();
    var Desc=$("#ILLSDesc").val();
    $("#ILLSName").val(Desc);
    if(ID==""){
        $.messager.alert('提示','请选择待维护的记录',"info");
         return false;
    }
    if(Type=="1"){ 
        var title="疾病解释-"+Desc;
        document.getElementById("TIllExplain").innerHTML=$g("疾病解释");
    }
    if(Type=="2"){ 
        var title="运动指导-"+Desc;
        
        document.getElementById("TIllExplain").innerHTML=$g("运动指导");
    }
    if(Type=="3"){ 
        var title="饮食指导-"+Desc;
        document.getElementById("TIllExplain").innerHTML=$g("饮食指导");
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
                text:$g('保存'),
                id:'saveILLE_btn',
                handler:function(){
                    SaveILLEForm(ID,Type)
                }
            },{
                text:$g('关闭'),
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
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
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
            $.messager.alert('提示',$g("保存失败")+":  "+flag,"error");
        }
        
    }
    
//疾病与建议对照
function ILLED_Click(){
	   
	   var LocListID=$("#LocList").combobox('getValue');
        var record = $("#IllnessFindGrid").datagrid("getSelected"); 
    
            if (!(record)) {
                $.messager.alert('提示','请选择待维护的记录!',"warning");
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
                    title:"疾病与建议对照-"+illDesc,
                    modal:true,
                    content:'<iframe id="timeline" frameborder="0" src="dhcpeilledrelate.hisui.csp?selectrow='+illRowId+'&selectrowDesc='+illDesc+'" width="100%" height="99%" ></iframe>'
                }); 
                */
                lnk="dhcpe.ct.illedrelate.csp"+"?selectrow="+illRowId+"&selectrowDesc="+illDesc+"&SelectLocID="+LocListID;
                    
                websys_lu(lnk,false,'iconCls=icon-w-edit,width=1250,height=600,hisui=true,title='+$g('疾病与建议对照')+'-'+$g(illDesc));

            }
}

//疾病与项目对照
function IllItem_Click(){

		var LocListID=$("#LocList").combobox('getValue');
        var record = $("#IllnessFindGrid").datagrid("getSelected"); 
    
            if (!(record)) {
                $.messager.alert('提示','请选择待维护的记录!',"warning");
                return;
            } else {  
                var illDesc=record.ED_DiagnoseConclusion
                var illRowId=record.ED_RowId
                
                lnk="dhcpe.ct.illitem.csp"+"?selectrow="+illRowId+"&selectrowDesc="+illDesc+"&SelectLocID="+LocListID;
                    
                websys_lu(lnk,false,'iconCls=icon-w-edit,width=1320,height=600,hisui=true,title='+$g("疾病与项目对照")+'-'+$g(illDesc));

            }
}

    
//别名维护
function Alias_Click(){

    var LocListID=$("#LocList").combobox('getValue');
    var record = $("#IllnessFindGrid").datagrid("getSelected"); 
    
            if (!(record)) {
                $.messager.alert('提示','请选择待维护的记录!',"warning");
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
                    title:$g("别名维护-")+$g(illDesc),
                    modal:true,
                    width: 800,
        			height: 500,
                    content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
                    
                }); 
                
            }
}

//新增
function AddData()
{
    
    $("#myWin").show();
     
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:$g('保存'),
                id:'save_btn',
                handler:function(){
                    SaveForm("")
                }
            },{
                text:$g('关闭'),
                handler:function(){
                    myWin.close();
                }
            }]
        });
        $('#form-save').form("clear");
        var MaxCode=tkMakeServerCall("web.DHCPE.IllnessStandard","GetMaxCode");
        $("#IllCode").val(MaxCode);
        //默认选中
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
    
         $.messager.alert('提示','疾病编号不能为空',"info");
        return false
    } 
    
    var Illness="N";
    var iCommonIllness="N"
    var CommonIllness=$("#CommonIllness").checkbox('getValue');
    if(CommonIllness) {iCommonIllness="Y";}
    
    
    var DiagnoseConclusion=$("#IllDesc").val();
    if (""==DiagnoseConclusion){
        $("#IllDesc").focus();
        
        $.messager.alert('提示','疾病名称不能为空',"info");
        return false
    } 
    
    var InsertType=""
    
    var IllAlias=$("#IllAlias").val();
    
    
    var Detail=$("#IllDetail").val()
    if (""==Detail){
        
        $.messager.alert('提示','疾病建议不能为空',"info");
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
	    $.messager.alert('提示',"疾病名称:"+$g(DiagnoseConclusion)+"   已存在！","error");
	    return false;
    }
    var Instring=id+"^"+Code+"^"+DiagnoseConclusion+"^"+Detail+"^"+Illness+"^"+iCommonIllness+"^"+UserId+"^"+InsertType+"^"+IllAlias+"^"+ToReport+"^"+SexDR+"^"+Type+"^"+iNoActive+"^"+TypeNew+"^"+ILLSStation+"^"+FatherIll+"^"+note+"^"+iIfCompare;
    
    
    var ReturnStr=tkMakeServerCall("web.DHCPE.CT.IllnessStandard","UpdateIll",Instring,LocID);
    var flag=ReturnStr.split("^")[0];
    if(flag==0){
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
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
            $.messager.alert('提示',"保存失败"+ReturnStr,"error");
        }
        
    }
    
function UpdateData()
{
    var ID=$("#ILLSRowId").val();
    if(ID==""){
        $.messager.alert('提示',"请选择待修改的记录","info");
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
                title:'修改',
                modal:true,
                buttons:[{
                    text:$g('保存'),
                    id:'save_btn',
                    handler:function(){
                        SaveForm(ID)
                    }
                },{
                    text:$g('关闭'),
                    handler:function(){
                        myWin.close();
                    }
                }]
            });                         
    }
}

//查询
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

//清屏
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
            {field:'ED_Code',width:'100',title:'编号'},
            {field:'ED_DiagnoseConclusion',width:'150',title:'疾病名称'},
        ]],
        columns:[[
            {field:'ED_RowId',title:'ID',hidden: true},
            {field:'ED_CommonIllness',width:80,title:'常见病'},
            {field:'TSex',width:80,title:'性别'},
            {field:'NoActive',width:80,title:'激活',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
            },
       		{field:'Empower',width:90,title:'单独授权',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			
			},
			{ field:'TEffPowerFlag',width:100,align:'center',title:'当前科室授权',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			},
            {field:'TType',width:100,title:'类型'},
            {field:'AliasDesc',width:120,title:'别名'},
            {field:'ED_Detail',width:650,title:'建议'},
			
            
        ]],
        onSelect: function (rowIndex, rowData) {
               
                $("#ILLSRowId").val(rowData.ED_RowId);
                $("#ILLSDesc").val(rowData.ED_DiagnoseConclusion);
                if(rowData.Empower=="Y"){	
				$("#BRelateLoc").linkbutton('enable');
				$("#BPower").linkbutton({text:$g('取消授权')});
			}else{
					$("#BRelateLoc").linkbutton('disable');
					$("#BPower").linkbutton('enable');
					$("#BPower").linkbutton({text:$g('单独授权')})
				
			}	
                
                    
        }
        
            
    })
}


function InitCombobox(){
    //性别
    var SexObj = $HUI.combobox("#Sex",{
        valueField:'id',
        textField:'text',
        panelHeight:'100',
        data:[
            {id:'M',text:$g('男')},
            {id:'F',text:$g('女')},
            {id:'N',text:$g('不限')},
           
        ]

        });
        
    //类型
    var TypeObj = $HUI.combobox("#Type",{
        valueField:'id',
        textField:'text',
        panelHeight:'100',
        data:[
            {id:'1',text:$g('团体报告')},
            {id:'2',text:$g('妇科统计')},
            {id:'3',text:$g('阳性统计')},
            
        ]

        });
        
    // 标记
	var SexObj = $HUI.combobox("#TypeNew",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'1',text:'分类'},
            {id:'2',text:'疾病'},
            {id:'3',text:'项目'},
           
        ]

		});
		
	// 站点
	var SexObj = $HUI.combobox("#ILLSStation",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'

		});
	// 特殊分类
	var SexObj = $HUI.combobox("#FatherIll",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindIllness&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc'

		});
	
}

