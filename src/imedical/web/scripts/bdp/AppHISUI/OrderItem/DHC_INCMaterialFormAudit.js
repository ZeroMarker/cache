/// Function:材料数据审批流  
/// Creator: sunfengchao  
var INC_SAVE_ACTION_URL="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCINCMaterialAudit&pClassMethod=SysnazeINCItmData&pEntityName=web.Entity.CT.INCMaterialEntity";
var TARI_SAVE_ACTION_URL="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCINCMaterialAudit&pClassMethod=SysnazeTARItmData&pEntityName=web.Entity.CT.DHCAuditTarItem";
var ARCIM_SAVE_ACTION_URL="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCINCMaterialAudit&pClassMethod=SysnazeARCIMData&pEntityName=web.Entity.CT.DHCAuditARCIM";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCINCMaterialAudit&pClassMethod=SaveData&pEntityName=web.Entity.CT.DHCINCMaterialAudit";
var Refuse_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCINCMaterialAudit&pClassMethod=RefuseAuditStatus";
 
 
var HospId=2; 
var bizRole="" ;// 角色 == 安全组 ="ywgl" 
var procInsId=""; //  流程id ="1656960600711700481"
var taskId="" ;
var initiator ="" ;
function GetRequest() {
       var url = location.search; //获取url中"?"符后的字串 
       console.log(url)  
       var theRequest = new Object();   
       if (url.indexOf("?") != -1) {   
          var str = url.substr(1);   
          strs = str.split("&");   
          for(var i = 0; i < strs.length; i ++) {   
             theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);   
          }   
       }   
       return theRequest;   
    }   
     
    
    procInsId= GetRequest().procInsId;
    bizRole = GetRequest().bizRole; 
    taskId = GetRequest().taskId;   // 任务id
    initiator =  GetRequest().initiator;  // 拟稿发起人  
    /// alert(procInsId+"^"+taskId+"^"+bizRole+"^"+initiator)
  
var init = function(){
     var URL_Icon="../scripts/bdp/Framework/icons/";  
    
       //失焦事件
     $('#InciDesc').bind('blur',function(){
          var InciDesc=$("#InciDesc").val()  
          var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",InciDesc)  
          $("#InciAlias").val(PYCode)                                       
      });
         
        //物资 进口标志  
      var ImportFlag = $HUI.combobox("#ImportFlag",{
        valueField:'id',
        textField:'text',
        data:[
            {id:'HM',text:'国产'},
            {id:'IM',text:'进口'} ,
            {id:'JM',text:'合资'} ,
            {id:'UM',text:'未分类'}       
        ] 
    });    
    
       /// 基本单位
      var BUom=$HUI.combobox('#BUom',{   
            url:$URL+"?ClassName=web.DHCBL.CT.CTUOM&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'CTUOMRowId',
            textField:'CTUOMDesc'
        });
       /// 入库单位
      var PUom=$HUI.combobox('#PUom',{   
            url:$URL+"?ClassName=web.DHCBL.CT.CTUOM&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'CTUOMRowId',
            textField:'CTUOMDesc'
        }); 

        /// 大包装单位
      var PackUomMax=$HUI.combobox('#PackUomMax',{   
            url:$URL+"?ClassName=web.DHCBL.CT.CTUOM&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'CTUOMRowId',
            textField:'CTUOMDesc'
      });
         
        ///  生产商 
      var Manf=$HUI.combobox('#Manf',{   
            url:$URL+"?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&&ResultSetType=array",
            valueField:'RowId',
            textField:'Description'
      });
      
        /// 产地 OriginBox
       var OriginBox=$HUI.combobox('#OriginBox',{   
            url:$URL+"?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrigin&ResultSetType=array",
            valueField:'RowId',
            textField:'Description'
      });
      
      ///供应商  PbVendor
       var PbVendor=$HUI.combobox('#PbVendor',{   
            url:$URL+"?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&&hospid="+HospId+"&ResultSetType=array",
            valueField:'RowId',
            textField:'Description'
      });    
      /// 库存类组
      var MaxStkGrp=$HUI.combobox('#MaxStkGrp',{   
            url:$URL+"?ClassName=web.DHCBL.CT.DHCINCMaterialAudit&QueryName=GetCatGrpList&&hospid="+HospId+"&ResultSetType=array",
            valueField:'SCGRowId',
            textField:'SCGDesc',
            onHidePanel: function(){      
              $("#MaxStkCat").combobox("setValue",'');//清空 
              var id = $('#MaxStkGrp').combobox('getValue');    
              $.ajax({ 
                    type: "POST", 
                    url: $URL+"?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&&hospid="+HospId+"&ResultSetType=array",
                    cache: false, 
                    dataType : "json", 
                    success: function(data){ 
                        $("#MaxStkCat").combobox("loadData",data); 
                    } 
              });  
            }             
         } );

         /// 库存分类   
      var MaxStkCat=$HUI.combobox('#MaxStkCat',{    
            //url: $URL+"?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&&hospid="+HospId+"&StkGrpId="+id+"&ResultSetType=array",    
            valueField:'RowId',
            textField:'Description'
        });
        
        
        /// 收费项基本单位  
       var TARIUOM=$HUI.combobox('#TARIUOM',{   
            url:$URL+"?ClassName=web.DHCBL.CT.CTUOM&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'CTUOMRowId',
            textField:'CTUOMDesc'
        });
        
     /// 新病案首页子类  
       var TARIMCNew=$HUI.combobox('#TARIMCNew',{    
            url:$URL+"?ClassName=web.DHCBL.CT.DHCNewTarMRCate&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'NTARMCRowId',
            textField:'NTARMCDesc'
       });
     
     ///  收费项目子类  
     var TARISubCate=$HUI.combobox('#TARISubCate',{    
            url:$URL+"?ClassName=web.DHCBL.CT.DHCTarSubCate&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'TARSCRowId',
            textField:'TARSCDesc'
      });
         /// 收费会计子类  
     var TARIAcctCate=$HUI.combobox('#TARIAcctCate',{    
        url:$URL+"?ClassName=web.DHCBL.CT.DHCTarAcctCate&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
        valueField:'TARACRowId',
        textField:'TARACDesc'
    });
    ///  住院费用子类
    var TARIInpatCate=$HUI.combobox('#TARIInpatCate',{     
        url:$URL+"?ClassName=web.DHCBL.CT.DHCTarInpatCate&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
        valueField:'TARICRowId',
        textField:'TARICDesc'
   });
    /// 门诊费用子类
    var TARIOutpatCate=$HUI.combobox('#TARIOutpatCate',{     
        url:$URL+"?ClassName=web.DHCBL.CT.DHCTarOutpatCate&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
        valueField:'TAROCRowId',
        textField:'TAROCDesc'
    });
    /// 经济核算子类
     var TARIEMCCate=$HUI.combobox('#TARIEMCCate',{     
            url:$URL+"?ClassName=web.DHCBL.CT.DHCTarEMCCate&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'TARECRowId',
            textField:'TARECDesc'
      });
    
      /// 旧病案首页子类
        var TARIMRCate=$HUI.combobox('#TARIMRCate',{   
            url:$URL+"?ClassName=web.DHCBL.CT.DHCTarMRCate&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'TARMCRowId',
            textField:'TARMCDesc'
      });
     /// 新病案首页子类
        var TARIMCNew=$HUI.combobox('#TARIMCNew',{    
            url:$URL+"?ClassName=web.DHCBL.CT.DHCNewTarMRCate&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'NTARMCRowId',
            textField:'NTARMCDesc'
         });
         ///收费项进口标志 
    var TarImportFlag = $HUI.combobox("#TarImportFlag",{
        valueField:'id',
        textField:'text',
        data:[
            {id:'HM',text:'国产'},
            {id:'IM',text:'进口'} ,
            {id:'JM',text:'合资'} ,
            {id:'UM',text:'未分类'}       
        ] 
    });   
    
    
    
        /// 医嘱大类
        var ARCIMBillGrp=$HUI.combobox('#ARCIOrderCatDR',{    
            url:$URL+"?ClassName=web.DHCBL.CT.OECOrderCategory&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'ORCATRowId',
            textField:'ORCATDesc',
            onHidePanel: function(){   
              $("#ARCIMItemCatDR").combobox("setValue",'');//清空 
              var id = $('#ARCIOrderCatDR').combobox('getValue');    
              $.ajax({ 
                    type: "POST", 
                    url: $URL+"?ClassName=web.DHCBL.CT.ARCItemCat&QueryName=GetList&&hospid="+HospId+"&OrderCat="+id+"&ResultSetType=array",
                    cache: false, 
                    dataType : "json", 
                    success: function(data){ 
                        $("#ARCIMItemCatDR").combobox("loadData",data); 
                    } 
              });  
            }             
         } );
    
     /// 医嘱子类
       var ARCIMItemCatDR=$HUI.combobox('#ARCIMItemCatDR',{     
           // url:$URL+"?ClassName=web.DHCBL.CT.ARCItemCat&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'ARCICRowId',
            textField:'ARCICDesc'
       });
      /// 医嘱优先级
      var ARCIMDefPriorityDR=$HUI.combobox('#ARCIMDefPriorityDR',{   
            url:$URL+"?ClassName=web.DHCBL.CT.OECPriority&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'OECPRRowId',
            textField:'OECPRDesc'
        });
   
     /// 账单组
        var ARCIMBillGrp=$HUI.combobox('#ARCIMBillGrpDR',{    
            url:$URL+"?ClassName=web.DHCBL.CT.ARCBillGrp&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'ARCBGRowId',
            textField:'ARCBGDesc',
            onHidePanel: function(){   
              $("#ARCIMBillSubDR").combobox("setValue",'');//清空 
              var id = $('#ARCIMBillGrpDR').combobox('getValue');    
              $.ajax({ 
                    type: "POST", 
                    url: $URL+"?ClassName=web.DHCBL.CT.ARCBillSub&QueryName=GetDataForCmb1&&hospid="+HospId+"&ParRef="+id+"&ResultSetType=array",
                    cache: false, 
                    dataType : "json", 
                    success: function(data){ 
                        $("#ARCIMBillSubDR").combobox("loadData",data); 
                    } 
              });  
            }             
         } );
   
     /// 账单子组
     var ARCIMBillSubDR=$HUI.combobox('#ARCIMBillSubDR',{    
           // url:$URL+"?ClassName=web.DHCBL.CT.ARCBillSub&QueryName=GetDataForCmb1&ResultSetType=array",
            valueField:'ARCSGRowId',
            textField:'ARCSGDesc'
     });
     /// TPPatInsType  
     var ARCIMBillSubDR=$HUI.combobox('#TPPatInsType',{    
            url:$URL+"?ClassName=web.DHCBL.CT.PACAdmReason&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'REARowId',
            textField:'READesc'
     });  
     
     /// 计价单位 ARCIMBillingUOMDR
       var ARCIMBillingUOMDR=$HUI.combobox('#ARCIMBillingUOMDR',{   
            url:$URL+"?ClassName=web.DHCBL.CT.CTUOM&QueryName=GetDataForCmb1&&hospid="+HospId+"&ResultSetType=array",
            valueField:'CTUOMRowId',
            textField:'CTUOMDesc'
        });
    
      
     /// 页面打开待办时的弹窗 自动执行加载数据   
    if (bizRole=="initiator"){
         SubmitMaterItmData();
    }
    else if (bizRole=="task_1"){  
         AuditINCItmData();  // 物价办审批  
    } else if (bizRole=="task_2"){
         AuditARCIMData();
    } 
       
    //点击 审核  按钮
    $("#btnAudit").click(function(e){  
        if (bizRole=="initiator"){  // 拟稿提交 
            SaveINCFunLib();
        }
         else if (bizRole=="task_1"){  // 物价办 
           SaveTarFunLib();
        } else if (bizRole=="task_2"){
            SaveARCIMFunLib();
        } 
    });
    
       //点击 拒绝  按钮
    $("#btnRefuseAuit").click(function(e){  
        if (bizRole=="initiator"){  // 拟稿提交 
           ///  SaveINCFunLib();
        }
        if (bizRole=="task_1"){  // 物价办
            RefuseAuitData();
        } else if (bizRole=="task_2"){
            RefuseARCIMAuitData();
        }  
    });
      
     
    //点击 物价办 审批按钮
    function AuditINCItmData() {  
         $('#tabsINC').tabs('enableTab', 0);                 
         $('#tabsINC').tabs('enableTab', 1); 
         $('#tabsINC').tabs('disableTab', 2); 
         $('#tabsINC').tabs('select',1); 
         $('#INCItm-form-save').form("clear"); //优化弹窗清空  
         $('#TarItem-form-save').form("clear"); //优化弹窗清空 
         $('#ARCItmMast-form-save').form("clear"); //优化弹窗清空 
         
         
         $.cm({   //调用后台openData方法给表单赋值
               ClassName:"web.DHCBL.CT.DHCINCMaterialAudit",
               MethodName:"OpenINCItmData" ,
               procInsId:procInsId 
         },function(jsonData){   
                $('#INCItm-form-save').form("load",jsonData); 
                if (jsonData.Charge=="Y") {
                    $HUI.checkbox("#Charge").setValue(true); 
                }
                else{
                    $HUI.checkbox("#Charge").setValue(false); 
                }
                if (jsonData.HighValue=="Y") {
                    $HUI.checkbox("#HighValue").setValue(true); 
                }
                else{
                    $HUI.checkbox("#HighValue").setValue(false); 
                }
         }); 
         
          $.cm({   //调用后台openData方法给表单赋值
                       ClassName:"web.DHCBL.CT.DHCINCMaterialAudit",
                       MethodName:"OpenTarItmData" ,
                       procInsId:procInsId 
                 },function(jsonData){     
                       $('#TarItem-form-save').form("load",jsonData); 
                       //$('#TARIAlias').val(record.Alias);  //别名    
           });  
          
        var MaterialStr=tkMakeServerCall("web.DHCBL.CT.DHCINCMaterialAudit","GetINCItmForWJData",procInsId); 
        MaterialArr = MaterialStr.split("^");   
        $('#TARICode').val(MaterialArr[0]);  //收费项代码  
        $('#TARIDesc').val(MaterialArr[1]); //收费项名称         
        $('#TARISpec').val(MaterialArr[2]); //  规格 
        $('#TARIPrice').val(MaterialArr[4]); //  价格
        $('#TARIUOM').combobox('setValue',MaterialArr[3]); // 单位             
        $('#TARIInsuCode').val(MaterialArr[5]);  //  国家医保编码   
        $('#TARIInsuDesc').val(MaterialArr[6]);  //  国家医保名称       
        $('#TarImportFlag').combobox('setValue',MaterialArr[7]); //进口标志  
        $('#TARIAlias').val(MaterialArr[8]); //别名 
        
        
        
        
        $("#TARICode").attr("readonly", true); 
        $("#TARICode").css("opacity",0.3);
         
        $("#TARIDesc").attr("readonly", true); 
        $("#TARIDesc").css("opacity",0.3);
        $("#TARIAlias").attr("readonly", true); 
        $("#TARIAlias").css("opacity",0.3);
         
        
        $("#TARISpec").attr("readonly", true); 
        $("#TARISpec").css("opacity",0.3);
        
        $("#TARIPrice").attr("readonly", true); 
        $("#TARIPrice").css("opacity",0.3);
        
        $("#TARIInsuCode").attr("readonly", true); 
        $("#TARIInsuCode").css("opacity",0.3);
        
        $("#TARIInsuDesc").attr("readonly", true); 
        $("#TARIInsuDesc").css("opacity",0.3);
        // $('').val(MaterialArr[0]);  
        $("#TARIUOM").combobox("readonly", true);  // 单位  
        $("#TARIUOM").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
        $("#TarImportFlag").click(function(){return false;});   
        
        
        
        
         
        $("#InciCode").attr("readonly", true); 
        $("#InciCode").css("opacity",0.3);
         
        $("#InciDesc").attr("readonly", true); 
        $("#InciDesc").css("opacity",0.3);
        
        
        $("#InciAlias").attr("readonly", true); 
        $("#InciAlias").css("opacity",0.3);
        
        $("#Spec").attr("readonly", true); 
        $("#Spec").css("opacity",0.3);
        
        $("#Model").attr("readonly", true); 
        $("#Model").css("opacity",0.3);
        
        $("#Manf").combobox("readonly", true);  //生产商 
        $("#Manf").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
        
        $("#BUom").combobox("readonly", true);  //单位 
        $("#BUom").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
        
        $("#PUom").combobox("readonly", true);  //入库单位 
        $("#PUom").next('span').children('.combo-text').first().css('background-color',"#ECECEC"); 
         
        
        $("#Factor").attr("readonly", true); 
        $("#Factor").css("opacity",0.3);
        
        $("#PackUomMax").combobox("readonly", true);  //大包装单位
        $("#PackUomMax").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
        
        $("#PackUomFacMax").attr("readonly", true); 
        $("#PackUomFacMax").css("opacity",0.3);
        
        $("#SP").attr("readonly", true); 
        $("#SP").css("opacity",0.3);
        
        $("#MaxStkGrp").combobox("readonly", true);  //库存类组 
        $("#MaxStkGrp").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
        
        $("#MaxStkCat").combobox("readonly", true);  //库存分类
        $("#MaxStkCat").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
        
        $("#MatInsuCode").attr("readonly", true); 
        $("#MatInsuCode").css("opacity",0.3);
        
        $("#MatInsuDesc").attr("readonly", true); 
        $("#MatInsuDesc").css("opacity",0.3);
         
        $("#OriginBox").combobox("readonly", true);  //产地 
        $("#OriginBox").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
        
        $("#INCBarCode").attr("readonly", true); 
        $("#INCBarCode").css("opacity",0.3);
                
        $("#PbVendor").combobox("readonly", true);  //供应商
        $("#PbVendor").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
        
        
        $("#RegisterNo").attr("readonly", true); 
        $("#RegisterNo").css("opacity",0.3);
        
        $("#ImportFlag").combobox("readonly", true);  // 进口标志 
        $("#ImportFlag").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
       
        
        
        $("#INCEndDate").datebox("readonly", true);  
        $("#INCEndDate").next('span').children('.combo-text').first().css('background-color',"#ECECEC");        
        
        $("#Charge").click(function(){return false;});   
        $("#HighValue").click(function(){return false;});  
        
        
        
        
         
        $("#vstp").empty();
        var WZCurrentTime= tkMakeServerCall("web.DHCBL.CT.DHCINCMaterialAudit","GetHistoryDateTime","INC") ;
        var WZtararr=WZCurrentTime.split("^") 
         
        var WJCurrentTime= tkMakeServerCall("web.DHCBL.CT.DHCINCMaterialAudit","GetCurrentDateTime","WJ") ;
        var WJtararr=WJCurrentTime.split("^")  
        $("#vstp").vstep({ 
                stepHeight:130,
                currentInd:2, 
                items:[{
                        title:'新增物资', 
                        context:"<div class='cntt'><div>"+WZtararr[0]+"</div><div>"+WZtararr[1]+"</div></div>"
                    },{
                        title:'物价办审批' ,
                        context:"<div class='cntt'><div>"+WJtararr[0]+"</div><div>"+WJtararr[1]+"</div></div>"
                    },{
                        title:"医务处审批" 
                    } ,{
                        title:"完成"
                    }]
            });        
    }
     
      
    /// 新增 收费项 审批 
    function SaveTarFunLib(){
        var TARICode=$('#TARICode').val(); //  收费项代码 
        var TARIDesc=$('#TARIDesc').val(); // 收费项名称  
        var TARIAlias=$('#InciAlias').val(); // 收费项别名
        var TARISubCate=$('#TARISubCate').combobox('getValue');
        var TARIAcctCate=$('#TARIAcctCate').combobox('getValue');       
        var TARIInpatCate= $('#TARIInpatCate').combobox('getValue');
        var TARIOutpatCate= $('#TARIOutpatCate').combobox('getValue'); 
        var TARIEMCCate= $('#TARIEMCCate').combobox('getValue');
        var TARIMRCate= $('#TARIMRCate').combobox('getValue');      
        var TARIMCNew= $('#TARIMCNew').combobox('getValue'); 
        var TARIStartDate=$('#TARIStartDate').datebox('getValue'); 
        var TARIEndDate=$('#TARIEndDate').datebox('getValue');  //开始日期 
        var AuditComment = $('#AuditComment').val();   
        if (TARICode==""){
            $.messager.alert('错误提示','收费项代码不能为空!',"error");
            return;
        } 
        if (TARIDesc==""){
            $.messager.alert('错误提示','收费项名称不能为空!',"error");
            return;
        } 
        
        if (TARIStartDate=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return;
        }   
        
     
       if (TARIAlias==""){
            $.messager.alert('错误提示','收费项别名不能为空!',"error");
            return;
        } 
        if (TARISubCate=="")
        {
            $.messager.alert('错误提示','收费项目子类不能为空!',"error");
            return;
        }
        if (TARIAcctCate=="")
        {
            $.messager.alert('错误提示','会计费用子类不能为空!',"error");
            return;
        }
        if (TARIInpatCate=="")
        {
            $.messager.alert('错误提示','住院费用子类不能为空!',"error");
            return;
        }
        if (TARIOutpatCate=="")
        {
            $.messager.alert('错误提示','门诊费用子类不能为空!',"error");
            return;
        }
        if (TARIEMCCate=="")
        {
            $.messager.alert('错误提示','经济核算子类不能为空!',"error");
            return;
        }
        if (TARIMRCate=="")
        {
            $.messager.alert('错误提示','旧病案首页子类不能为空!',"error");
            return;
        }
        if (TARIMCNew=="")
        {
            $.messager.alert('错误提示','新病案首页子类不能为空!',"error");
            return;
        } 
       
     
        $.messager.confirm('提示', "确认要提交审批吗?", function(r){
            if (r){
                $('#TarItem-form-save').form('submit', { 
                    url: TARI_SAVE_ACTION_URL, 
                    onSubmit: function(param){ 
                         param.AuditID = procInsId;
                         param.LinkHospId = HospId;
                         param.TaskId=taskId;
                         param.AuditComment=AuditComment;
                    },
                    success: function (data) {   
                        var data=eval('('+data+')'); 
                        if (data.success == 'true') { 
                            $.messager.popover({msg: '审批成功！',type:'success',timeout: 1000});  
                            $('#myWin').dialog('close'); // close a dialog
                        } 
                        else { 
                            var errorMsg ="审批失败！"
                            if (data.errorinfo) {
                                errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                            }
                            $.messager.alert('操作提示',errorMsg,"error");
                        } 
                    } 
             });
        }
     })     
    }
     
       
    
    //点击 医务处 审批按钮 生成 医嘱项到中间审批表 
    function AuditARCIMData() {   
                 $('#tabsINC').tabs('enableTab', 0);                 
                 $('#tabsINC').tabs('enableTab', 1);                 
                 $('#tabsINC').tabs('enableTab', 2); 
                 $('#tabsINC').tabs('select',2);
                 $('#INCItm-form-save').form("clear"); //优化弹窗清空  
                 $('#TarItem-form-save').form("clear"); //优化弹窗清空 
                 $('#ARCItmMast-form-save').form("clear"); //优化弹窗清空 
                 $HUI.checkbox("#ARCIMOrderOnItsOwn").setValue(true); 
                  $.cm({   //调用后台openData方法给表单赋值
                       ClassName:"web.DHCBL.CT.DHCINCMaterialAudit",
                       MethodName:"OpenINCItmData" ,
                       procInsId:procInsId
                 },function(jsonData){     
                        $('#INCItm-form-save').form("load",jsonData); 
                        if (jsonData.Charge=="Y") {
                            $HUI.checkbox("#Charge").setValue(true); 
                        }
                        else{
                            $HUI.checkbox("#Charge").setValue(false); 
                        }
                        if (jsonData.HighValue=="Y") {
                            $HUI.checkbox("#HighValue").setValue(true); 
                        }
                        else{
                            $HUI.checkbox("#HighValue").setValue(false); 
                        }
                 }); 
               
                  $.cm({   //调用后台openData方法给表单赋值
                       ClassName:"web.DHCBL.CT.DHCINCMaterialAudit",
                       MethodName:"OpenTarItmData" ,
                       procInsId:procInsId 
                 },function(jsonData){     
                        $('#TarItem-form-save').form("load",jsonData); 
                       // $('#TARIAlias').val(record.Alias);  //别名    
                 }); 
                  
                  
                $("#TARICode").attr("readonly", true); 
                $("#TARICode").css("opacity",0.3);
                 
                $("#TARIDesc").attr("readonly", true); 
                $("#TARIDesc").css("opacity",0.3);
                $("#TARIAlias").attr("readonly", true); 
                $("#TARIAlias").css("opacity",0.3);
                 
                
                $("#TARISpec").attr("readonly", true); 
                $("#TARISpec").css("opacity",0.3);
                
                $("#TARIPrice").attr("readonly", true); 
                $("#TARIPrice").css("opacity",0.3);
                
                $("#TARIInsuCode").attr("readonly", true); 
                $("#TARIInsuCode").css("opacity",0.3);
                
                $("#TARIInsuDesc").attr("readonly", true); 
                $("#TARIInsuDesc").css("opacity",0.3);
                // $('').val(MaterialArr[0]);  
                $("#TARIUOM").combobox("readonly", true);  // 单位  
                $("#TARIUOM").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                $("#TarImportFlag").click(function(){return false;});   
                
                
                
                
                 
                $("#InciCode").attr("readonly", true); 
                $("#InciCode").css("opacity",0.3);
                 
                $("#InciDesc").attr("readonly", true); 
                $("#InciDesc").css("opacity",0.3);
                
                
                $("#InciAlias").attr("readonly", true); 
                $("#InciAlias").css("opacity",0.3);
                
                $("#Spec").attr("readonly", true); 
                $("#Spec").css("opacity",0.3);
                
                $("#Model").attr("readonly", true); 
                $("#Model").css("opacity",0.3);
                
                $("#Manf").combobox("readonly", true);  //生产商 
                $("#Manf").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                $("#BUom").combobox("readonly", true);  //单位 
                $("#BUom").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                $("#PUom").combobox("readonly", true);  //入库单位 
                $("#PUom").next('span').children('.combo-text').first().css('background-color',"#ECECEC"); 
                 
                
                $("#Factor").attr("readonly", true); 
                $("#Factor").css("opacity",0.3);
                
                $("#PackUomMax").combobox("readonly", true);  //大包装单位
                $("#PackUomMax").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                $("#PackUomFacMax").attr("readonly", true); 
                $("#PackUomFacMax").css("opacity",0.3);
                
                $("#SP").attr("readonly", true); 
                $("#SP").css("opacity",0.3);
                
                $("#MaxStkGrp").combobox("readonly", true);  //库存类组 
                $("#MaxStkGrp").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                $("#MaxStkCat").combobox("readonly", true);  //库存分类
                $("#MaxStkCat").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                $("#MatInsuCode").attr("readonly", true); 
                $("#MatInsuCode").css("opacity",0.3);
                
                $("#MatInsuDesc").attr("readonly", true); 
                $("#MatInsuDesc").css("opacity",0.3);
                 
                $("#OriginBox").combobox("readonly", true);  //产地 
                $("#OriginBox").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                $("#INCBarCode").attr("readonly", true); 
                $("#INCBarCode").css("opacity",0.3);
                        
                $("#PbVendor").combobox("readonly", true);  //供应商
                $("#PbVendor").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                
                $("#RegisterNo").attr("readonly", true); 
                $("#RegisterNo").css("opacity",0.3);
                
                $("#ImportFlag").combobox("readonly", true);  // 进口标志 
                $("#ImportFlag").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
               
                
                
                $("#INCEndDate").datebox("readonly", true);  
                $("#INCEndDate").next('span').children('.combo-text').first().css('background-color',"#ECECEC");        
                
                $("#Charge").click(function(){return false;});   
                $("#HighValue").click(function(){return false;});   
                  
                  
                  
                $("#TARISubCate").combobox("readonly", true);   
                $("#TARISubCate").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                
                $("#TARIAcctCate").combobox("readonly", true);  //供应商
                $("#TARIAcctCate").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                
                $("#TARIInpatCate").combobox("readonly", true);  //供应商
                $("#TARIInpatCate").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                
                $("#TARIOutpatCate").combobox("readonly", true);  //供应商
                $("#TARIOutpatCate").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                
                $("#TARIEMCCate").combobox("readonly", true);  //供应商
                $("#TARIEMCCate").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                
                $("#TARIMRCate").combobox("readonly", true);  //供应商
                $("#TARIMRCate").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                
                $("#TARIMCNew").combobox("readonly", true);  //供应商
                $("#TARIMCNew").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                
                $("#TPPatInsType").combobox("readonly", true);  //供应商
                $("#TPPatInsType").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                 
                 
                $("#TarImportFlag").combobox("readonly", true);  // 进口标志
                $("#TarImportFlag").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
                
                $("#TARIStartDate").datebox("readonly", true);  
                $("#TARIStartDate").next('span').children('.combo-text').first().css('background-color',"#ECECEC");        
        
                $("#TARIEndDate").datebox("readonly", true);  
                $("#TARIEndDate").next('span').children('.combo-text').first().css('background-color',"#ECECEC");        
        
                  
                  
                  
                $("#vstp").empty();
                var WZCurrentTime= tkMakeServerCall("web.DHCBL.CT.DHCINCMaterialAudit","GetHistoryDateTime","INC") ;
                var WZtararr=WZCurrentTime.split("^") 
                 
                var WJCurrentTime= tkMakeServerCall("web.DHCBL.CT.DHCINCMaterialAudit","GetHistoryDateTime","WJ") ;
                var WJtararr=WJCurrentTime.split("^")  
                 
                var YWCurrentTime= tkMakeServerCall("web.DHCBL.CT.DHCINCMaterialAudit","GetCurrentDateTime","YW") ;
                var YWtararr=YWCurrentTime.split("^") 
                
                
                
                 
                
                $("#vstp").vstep({ 
                        stepHeight:130, 
                        currentInd:3,
                        onSelect:function(ind,item){ }, 
                        items:[{
                                title:'新增物资', 
                                context:"<div class='cntt'><div>"+WZtararr[0]+"</div><div>"+WZtararr[1]+"</div></div>"
                            },{
                                title:'物价办审批' ,
                                context:"<div class='cntt'><div>"+WJtararr[0]+"</div><div>"+WJtararr[1]+"</div></div>"
                            },{
                                title:"医务处审批" ,
                                context:"<div class='cntt'><div>"+YWtararr[0]+"</div><div>"+YWtararr[1]+"</div></div>"
                            } ,{
                                title:"完成"
                            }]
                    }); 
                   
                            
                $('#ARCItmMast-form-save').form("clear"); //优化弹窗清空         
                var MaterialStr=tkMakeServerCall("web.DHCBL.CT.DHCINCMaterialAudit","GetINCItmForWJData",procInsId) ;
                MaterialArr = MaterialStr.split("^");   
                $('#ARCIMCode').val(MaterialArr[0]);  //医嘱项代码  
                $('#ARCIMDesc').val(MaterialArr[1]); //医嘱项名称     
                $('#ARCIMBillingUOMDR').combobox('setValue',MaterialArr[3]); // 单位   
                ///$('#TARIAlias').val(MaterialArr[8]); //别名    
                
                $("#ARCIMCode").attr("readonly", true); 
                $("#ARCIMCode").css("opacity",0.3);
                 
                $("#ARCIMDesc").attr("readonly", true); 
                $("#ARCIMDesc").css("opacity",0.3);
                $("#ARCIMBillingUOMDR").combobox("readonly", true);  //  
                $("#ARCIMBillingUOMDR").next('span').children('.combo-text').first().css('background-color',"#ECECEC");
               
                  
    }
     
      
     
    /// 新增 医嘱项 审批 
    function SaveARCIMFunLib(){
        var ARCIMCode=$('#ARCIMCode').val(); //  医嘱项代码 
        var ARCIMDesc=$('#ARCIMDesc').val(); // 医嘱项名称  
        var TARIAlias=$('#InciAlias').val(); //医嘱项 别名
        var ARCIOrderCatDR=$('#ARCIOrderCatDR').combobox('getValue');
        var ARCIMItemCatDR=$('#ARCIMItemCatDR').combobox('getValue');       
        var ARCIMBillGrpDR= $('#ARCIMBillGrpDR').combobox('getValue');
        var ARCIMBillSubDR= $('#ARCIMBillSubDR').combobox('getValue');  
        var ARCIMEffDate=$('#ARCIMEffDate').datebox('getValue');  //开始日期 
        var ARCIMEffDateTo=$('#ARCIMEffDateTo').datebox('getValue'); 
        var AuditComment = $('#AuditComment').val();  
        if (ARCIMCode==""){
            $.messager.alert('错误提示','医嘱项代码不能为空!',"error");
            return;
        } 
        if (ARCIMDesc==""){
            $.messager.alert('错误提示','医嘱项名称不能为空!',"error");
            return;
        } 
        if (ARCIOrderCatDR=="")
        {
            $.messager.alert('错误提示','医嘱大类不能为空!',"error");
            return;
        }
        if (ARCIMItemCatDR=="")
        {
            $.messager.alert('错误提示','医嘱子类不能为空!',"error");
            return;
        }
        if (ARCIMBillGrpDR=="")
        {
            $.messager.alert('错误提示','账单组不能为空!',"error");
            return;
        }
        if (ARCIMBillSubDR=="")
        {
            $.messager.alert('错误提示','账单子组不能为空!',"error");
            return;
        } 
        if (ARCIMEffDate=="")
        {
            $.messager.alert('错误提示','医嘱项开始日期不能为空!',"error");
            return;
        }   

        
         /*
       if (TARIAlias==""){
            $.messager.alert('错误提示','医嘱项别名不能为空!',"error");
            return;
        }  
         */
     
        $.messager.confirm('提示', "确认要提交审批吗?", function(r){
            if (r){
                $('#ARCItmMast-form-save').form('submit', { 
                    url: ARCIM_SAVE_ACTION_URL, 
                    onSubmit: function(param){ 
                         param.AuditID = procInsId;
                         param.LinkHospId = HospId;
                         param.TaskId=taskId;
                         param.AuditComment=AuditComment;
                    },
                    success: function (data) {   
                        var data=eval('('+data+')'); 
                        if (data.success == 'true') { 
                            $.messager.popover({msg: '审批成功！',type:'success',timeout: 1000});   
                        } 
                        else { 
                            var errorMsg ="审批失败！"
                            if (data.errorinfo) {
                                errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                            }
                            $.messager.alert('操作提示',errorMsg,"error");
                        } 
                    } 
             });
        }
     })     
    } 
     
      
    /// 物价办拒绝审批 
    function RefuseAuitData()
    {      
            var AuditComment = $('#AuditComment').val();   
            $.messager.confirm('提示', '确定要拒绝审批吗?', function(r){
            if (r){   
                $.ajax({
                    url:Refuse_ACTION_URL,  
                    data:{ 
                        "procInsId":procInsId,
                        'taskId':taskId,
                        'comment':AuditComment,
                        'WJAudit':'R'
                    },  
                    type:"POST",  
                    success: function(data){
                              var data=eval('('+data+')'); 
                              if (data.success == 'true') {  
                                 $.messager.alert('操作提示','拒绝成功！',"success"); 
                              } 
                              else { 
                                var errorMsg ="拒绝失败！"
                                if (data.info) {
                                    errorMsg =errorMsg+ '<br/>错误信息:' + data.info
                                }
                                 $.messager.alert('操作提示',errorMsg,"error"); 
                            }           
                    }  
                }) 
            }
        });
     
    }
       
    ///医务处 拒绝审批 
 function RefuseARCIMAuitData()
    {      
            
            $.messager.confirm('提示', '确定要拒绝审批吗?', function(r){
            if (r){   
                var comment=$('#AuditComment').val();
                $.ajax({
                    url: Refuse_ACTION_URL,  
                    data:{ 
                         "procInsId":procInsId,
                         "taskId":taskId,
                         "comment":comment, 
                         'YWAudit':'R'
                    },  
                    type:"POST",  
                    success: function(data){
                              var data=eval('('+data+')'); 
                              if (data.success == 'true') {  
                                 $.messager.alert('操作提示','拒绝成功！',"success"); 
                              } 
                              else { 
                                var errorMsg ="拒绝失败！"
                                if (data.info) {
                                    errorMsg =errorMsg+ '<br/>错误信息:' + data.info
                                }
                                 $.messager.alert('操作提示',errorMsg,"error");
                    
                            }           
                    }  
                }) 
            }
        }); 
    }
       
     
    /// 审批保存数据 （新增和修改）
    function SaveFunLib()
    {     
        var TARIHISCode=$('#TARICode').val(); // HIS码 
        var TARIHISDesc=$('#TARIDesc').val(); //  HIS名称  
        var TARIChargeBasis=$('#TARIChargeBasis').val(); // 收费依据 
        var TARIMCNew= $('#TARIMCNew').combobox('getValue'); 
        var TARIRemark=$('#TARIRemark').val(); //  备注
        var TARIPriceRemark=$('#TARIPriceRemark').val(); // 物价备注 
        var TARIStartDate=$('#TARIStartDate').datebox('getValue');  
        var TARIEndDate=$('#TARIEndDate').datebox('getValue');   
        var TARIStateHVMFlag = $('#TARIStateHVMFlag').checkbox('getValue'); 
        
        if (TARIHISCode=="")
        {
            $.messager.alert('错误提示','HIS码不能为空!',"error");
            return;
        } 
        if (TARIHISDesc=="")
        {
            $.messager.alert('错误提示','HIS名称不能为空!',"error");
            return;
        } 
        if (TARIMCNew=="")
        {
            $.messager.alert('错误提示','新病案首页分类不能为空!',"error");
            return;
        } 
        var TarStr= TARIHISCode+"^"+TARIHISDesc+"^"+TARIChargeBasis+"^"+TARIMCNew+"^"+TARIRemark+"^"+TARIPriceRemark+"^"+TARIStartDate+"^"+TARIEndDate+"^"+TARIStateHVMFlag;  
        //console.log(TarStr)
        $.messager.confirm('提示', "确认要保存数据吗?", function(r){
        if (r){
            $.m({
                ClassName:'web.DHCBL.CT.DHCINCMaterialAudit',
                MethodName:'INCMaterialAudit', /// 'SynchronizeDataNew',
                "ID":procInsId,
                TarStr:TarStr,
                Type:type 
            },function(data){   
                          var data=eval('('+data+')');  
                          if (data.success == 'true') {  
                           ///  $.messager.popover({msg: '物价审批成功！',type:'success',timeout: 1000}); 
                            $.messager.alert('操作提示','审批成功！',"success"); 
                            $('#myWin').dialog('close'); 
                          } 
                          else {    
                            var errorMsg ="审批失败！"
                            if (data.errorinfo) {
                                errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                            }
                            $.messager.alert('操作提示',errorMsg,"error"); 
                }     
            })   
        }
    })
    } 
     
      
   /// 数据驳回后拟稿签收提交给物价办 
   function SubmitMaterItmData(){
                 $('#tabsINC').tabs('enableTab', 0);                 
                 $('#tabsINC').tabs('disableTab', 1);                 
                 $('#tabsINC').tabs('disableTab', 2); 
                 $('#tabsINC').tabs('select',0);
                 $('#INCItm-form-save').form("clear"); //优化弹窗清空  
                 $('#TarItem-form-save').form("clear"); //优化弹窗清空 
                 $('#ARCItmMast-form-save').form("clear"); //优化弹窗清空  
                  $.cm({   //调用后台openData方法给表单赋值
                       ClassName:"web.DHCBL.CT.DHCINCMaterialAudit",
                       MethodName:"OpenINCItmData" ,
                       procInsId:procInsId
                 },function(jsonData){     
                   
                        $('#INCItm-form-save').form("load",jsonData); 
                        if (jsonData.Charge=="Y") {
                            $HUI.checkbox("#Charge").setValue(true); 
                        }
                        else{
                            $HUI.checkbox("#Charge").setValue(false); 
                        }
                        if (jsonData.HighValue=="Y") {
                            $HUI.checkbox("#HighValue").setValue(true); 
                        }
                        else{
                            $HUI.checkbox("#HighValue").setValue(false); 
                        }
                 }); 
                    
                
        $("#InciCode").attr("readonly", false); 
        $("#InciCode").css("opacity","");
         
        $("#InciDesc").attr("readonly", false); 
        $("#InciDesc").css("opacity","");
        
        $("#InciAlias").attr("readonly", false); 
        $("#InciAlias").css("opacity","");
        
        $("#Spec").attr("readonly", false); 
        $("#Spec").css("opacity","");
        
        $("#Model").attr("readonly", false); 
        $("#Model").css("opacity","");
        
        $("#Manf").combobox("readonly", false);  //生产商 
        $("#Manf").next('span').children('.combo-text').first().css('background-color',"");
        
        $("#BUom").combobox("readonly", false);  //单位 
        $("#BUom").next('span').children('.combo-text').first().css('background-color',"");
        
        $("#PUom").combobox("readonly", false);  //入库单位 
        $("#PUom").next('span').children('.combo-text').first().css('background-color',""); 
         
        
        $("#Factor").attr("readonly", false); 
        $("#Factor").css("opacity","");
        
        $("#PackUomMax").combobox("readonly", false);  //大包装单位
        $("#PackUomMax").next('span').children('.combo-text').first().css('background-color',"");
        
        $("#PackUomFacMax").attr("readonly", false); 
        $("#PackUomFacMax").css("opacity","");
        
        $("#SP").attr("readonly", false); 
        $("#SP").css("opacity","");
        
        $("#MaxStkGrp").combobox("readonly", false);  //库存类组 
        $("#MaxStkGrp").next('span').children('.combo-text').first().css('background-color',"");
        
        $("#MaxStkCat").combobox("readonly", false);  //库存分类
        $("#MaxStkCat").next('span').children('.combo-text').first().css('background-color',"");
        
        $("#MatInsuCode").attr("readonly", false); 
        $("#MatInsuCode").css("opacity","");
        
        $("#MatInsuDesc").attr("readonly", false); 
        $("#MatInsuDesc").css("opacity","");
         
        $("#OriginBox").combobox("readonly", false);  //产地 
        $("#OriginBox").next('span').children('.combo-text').first().css('background-color',"");
        
        $("#INCBarCode").attr("readonly", false); 
        $("#INCBarCode").css("opacity","");
                
        $("#PbVendor").combobox("readonly", false);  //供应商
        $("#PbVendor").next('span').children('.combo-text').first().css('background-color',"");
        
        
        $("#RegisterNo").attr("readonly", false); 
        $("#RegisterNo").css("opacity","");
        
        $("#ImportFlag").combobox("readonly", false);  // 进口标志 
        $("#ImportFlag").next('span').children('.combo-text').first().css('background-color',"");
       
        
        
        $("#INCEndDate").datebox("readonly", false);  
        $("#INCEndDate").next('span').children('.combo-text').first().css('background-color',"");        
        
        $("#Charge").click(function(){return true;});   
        $("#HighValue").click(function(){return true;});  
            
                    
                    
                    
                    
                    
                    
                    
                $("#myWin").show();           
                var myWin = $HUI.dialog("#myWin",{
                    iconCls:'icon-w-edit',
                    resizable:true,
                    title:'新增物资', 
                    modal:true  ,
                    buttons:[{
                        text:'保存',  
                        id:'save_btn',
                        handler:function(){
                            SaveINCFunLib();
                        }
                    },{
                        text:'关闭',
                        //iconCls:'icon-cancel',
                        handler:function(){
                            myWin.close();
                        }
                    }]
                }); 
              $("#vstp").empty(); 
              var CurrentTime= tkMakeServerCall("web.DHCBL.CT.DHCINCMaterialAudit","GetCurrentDateTime","INC") ;
              var tararr=CurrentTime.split("^") 
              $("#vstp").vstep({ 
                stepHeight:120,
                currentInd:1,
                items:[ {
                        title:'新增物资',
                        context:"<div class='cntt'><div>"+tararr[0]+"</div><div>"+tararr[1]+"</div></div>"
                    },{
                        title:"物价办审批"  
                    },{
                        title:"医务处审批"
                    },{
                        title:"完成"
                    }]
            });   
              
              
         }
   
     
     function SaveINCFunLib(){
        var InciCode=$('#FInciCode').val(); // 物资代码 
        var InciDesc=$('#InciDesc').val(); // 物资名称  
        var InciAlias=$('#InciAlias').val(); // 物资别名
        var Spec= $('#Spec').val();  //规格
        var Model=$('#Model').val(); // 型号
        var Manf=$('#Manf').val(); // 生产商名称 
        var BUom= $('#BUom').combobox('getValue');  // 基本单位
        var PUom= $('#PUom').combobox('getValue');  // 入库单位
        var Factor=$('#Factor').val(); // 入库转换系数
        var PackUomMax= $('#PackUomMax').combobox('getValue');  // 大包装单位
        var PackUomFacMax= $('#PackUomFacMax').val();  //  大包装转换系数
        var SP=$('#SP').val(); //   零售价
        var MaxStkGrp= $('#MaxStkGrp').combobox('getValue'); // 类组 
        var MaxStkCat= $('#MaxStkCat').combobox('getValue'); // 库存分类
        var MatInsuCode=$('#MatInsuCode').val(); // 国家医保编码  
        var MatInsuDesc=$('#MatInsuDesc').val(); // 国家医保名称  
        var OriginBox=$('#OriginBox').val(); //  产地
        var INCBCode=$('#INCBarCode').val(); // 条码 
        var PbVendor=$('#PbVendor').val(); // 供应商名称  
        var RegisterNo=$('#RegisterNo').val(); // 注册证号  
        var ImportFlag= $('#ImportFlag').combobox('getValue'); //进口标志
        var INCEndDate=$('#INCEndDate').datebox('getValue');    //库存项结束日期
        var Charge=$('#Charge').checkbox('getValue');     // 是否收费
        var HighValue = $('#HighValue').checkbox('getValue');     //是否高值
        
        if (InciCode==""){
            $.messager.alert('错误提示','物资代码不能为空!',"error");
            return;
        } 
        if (InciDesc==""){
            $.messager.alert('错误提示','物资名称不能为空!',"error");
            return;
        } 
    
        if (InciAlias==""){
            $.messager.alert('错误提示','物资别名不能为空!',"error");
            return;
        } 
        if (BUom==""){
            $.messager.alert('错误提示','基本单位不能为空!',"error");
            return;
        } 
        if (PUom==""){
            $.messager.alert('错误提示','入库单位不能为空!',"error");
            return;
        } 
        if (MaxStkGrp==""){
            $.messager.alert('错误提示','类组不能为空!',"error");
            return;
        } 
        if (MaxStkCat==""){
            $.messager.alert('错误提示','库存分类不能为空!',"error");
            return;
        }  
        if (SP==""){
            $.messager.alert('错误提示','零售价不能为空!',"error");
            return;
        }  
       
        $.messager.confirm('提示', "确认要提交拟稿吗?", function(r){
            if (r){
                $('#INCItm-form-save').form('submit', { 
                    url: INC_SAVE_ACTION_URL, 
                    onSubmit: function(param){ 
                         param.BDPINCAProcInsId = procInsId;
                         param.MtaskId=taskId;
                         param.LinkHospId = HospId;
                    },
                    success: function (data) {   
                        var data=eval('('+data+')'); 
                        if (data.success == 'true') { 
                            $.messager.popover({msg: '拟稿提交成功！',type:'success',timeout: 1000});  
                        } 
                        else { 
                            var errorMsg ="更新失败！"
                            if (data.errorinfo) {
                                errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                            }
                            $.messager.alert('操作提示',errorMsg,"error");
                        } 
                    } 
             });
        }
     })     
    }
     
 
   
      
};
$(init);