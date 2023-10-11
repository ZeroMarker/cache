/// Function:材料数据审批流  
/// Creator: sunfengchao  
var INC_SAVE_ACTION_URL="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCINCMaterialAudit&pClassMethod=SysnazeINCItmData&pEntityName=web.Entity.CT.INCMaterialEntity";
var TARI_SAVE_ACTION_URL="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCINCMaterialAudit&pClassMethod=SysnazeTARItmData&pEntityName=web.Entity.CT.DHCAuditTarItem";
var ARCIM_SAVE_ACTION_URL="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCINCMaterialAudit&pClassMethod=SysnazeARCIMData&pEntityName=web.Entity.CT.DHCAuditARCIM";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCINCMaterialAudit&pClassMethod=SaveData&pEntityName=web.Entity.CT.DHCINCMaterialAudit";
var Refuse_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCINCMaterialAudit&pClassMethod=ChangeAuditStatus";
  
var HospId=2;
var LogonUserName=session['LOGON.USERNAME'];
var init = function(){
    var URL_Icon="../scripts/bdp/Framework/icons/"; 
     var tableName = "CT_BDP_CT.DHC_INCMaterialAudit";
     var hospComp=GenHospComp('CT_BDP_CT.DHC_INCMaterialAudit'); //多院区下拉框
     hospComp.options().onSelect=function(){  
           HospId=hospComp.getValue(); 
            $('#mygrid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.DHCINCMaterialAudit",
                QueryName:"GetList", 
                hospid:HospId
            });  
            $('#mygrid').datagrid('unselectAll'); 
        
        } 
  
       //失焦事件
     $('#InciDesc').bind('blur',function(){
          var InciDesc=$("#InciDesc").val()  
          var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",InciDesc) 
         // var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",PSDDesc,1) 
          $("#InciAlias").val(PYCode)                                       
      });
      
    
    var TextBDPINCAAudit = $HUI.combobox("#TextBDPINCAAudit",{
        valueField:'id',
        textField:'text',
        data:[
            {id:'Y',text:'已完成'},
            {id:'N',text:'未完成'}       
        ] 
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
                    url: $URL+"?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&&hospid="+HospId+"&StkGrpId="+id+"&ResultSetType=array",
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
   
    var columns =[[    
                  {field:'BDPINCAProcInsId',title:'流程实例id',width:100,sortable:true,hidden:true},     
                  {field:'BDPINCAMaterialCode',title:'物资代码',width:150,sortable:true},  
                  {field:'BDPINCAMaterialDesc',title:'物资名称',width:250,sortable:true}, 
                  {field:'BDPINCAAuditResult',title:'审批状态',width:160,sortable:true},
                  {field:'BDPINCAuditNextNode',title:'当前节点',width:160,sortable:true}, 
                  {field:'Spec',title:'规格',width:200,sortable:true}, 
                  {field:'Model',title:'型号',width:200,sortable:true},  
                  {field:'Alias',title:'物资别名',width:150,sortable:true},  
                  {field:'BUom',title:'基本单位',width:150,sortable:true},  
                  {field:'PUom',title:'入库单位',width:150,sortable:true}, 
                  {field:'Factor',title:'入库转换系数',width:150,sortable:true},   
                  {field:'PackUomMax',title:'大包装单位',width:150,sortable:true },                
                  {field:'PackUomFacMax',title:'大包装转换系数',width:150,sortable:true},  
                  {field:'SP',title:'零售价',width:150,sortable:true},  
                  {field:'StkGrp',title:'库存类组',width:250,sortable:true,align:'center'} ,   
                  {field:'StkCat',title:'库存分类',width:250,sortable:true,align:'center'} ,  
                  {field:'HighValue',title:'是否高值',width:150,sortable:true,formatter:ReturnFlagIcon},  
                  {field:'Origin',title:'产地',width:150,sortable:true},  
                  {field:'MatInsuCode',title:'国家医保编码',width:150,sortable:true},  
                  {field:'MatInsuDesc',title:'国家医保名称',width:150,sortable:true},  
                  {field:'INCBCode',title:'条码',width:150,sortable:true}, 
                  {field:'Manf',title:'生产厂商',width:250,sortable:true},
                  {field:'PbVendor',title:'供应商',width:150,sortable:true}, 
                  {field:'RegisterNo',title:'注册证号',width:200,sortable:true},                  
                  {field:'INCEndDate',title:'停用日期',width:150,sortable:true},
                  {field:'ImportFlag',title:'进口标志',width:150,sortable:true},  
                  {field:'BDPINCACreatDate',title:'同步日期',width:100,sortable:true}, 
                  {field:'BDPINCACreatTime',title:'同步时间',width:100,sortable:true}               
                ]];
                
                 
     //定义审批表
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.DHCINCMaterialAudit",
            QueryName:"GetList" , 
            hospid:HospId
        }, 
        columns: columns,  
        ClassTableName:'User.DHCINCMaterialAudit',
        SQLTableName:'BDP_INCItmAudit',
        pagination: true,   
        pageSize:20,
        pageList:[20,40,60,60,100,200,300,500,1000], 
        singleSelect:true,
        idField:'ID',  
        rownumbers:true 
    });
 
   //搜索回车事件
    $('#TextDesc,#TextCode').keyup(function(event){
        if(event.keyCode == 13) {
          SearchFunLib();
        }
    });  
    //查询按钮
    $("#btnSearch").click(function (e) { 
         SearchFunLib(); 
     })  
     
    //重置按钮
    $("#btnRefresh").click(function (e) { 
         ClearFunLib();
     })  
     
     /// 点击 新增材料的按钮  
    $("#btnAddINCItm").click(function(e){
          AddINCItmData();
    });
    
    //点击  查看审批进度的 按钮
    $("#btnCheckJDT").click(function(e){  
        CheckJDTData();
    });
     //点击 提交审批 按钮  针对被驳回的拟稿数据
     /*
    $("#btnSubmit").click(function(e){   
        SubmitINCItmData();
    });
     */
       
      
     //查询方法
    function SearchFunLib(){
        var code=$.trim($("#TextCode").val());
        var desc=$.trim($('#TextDesc').val()); 
        var audit=$('#TextBDPINCAAudit').combobox('getValue');
       // var datefrom=  $("#checkdatefrom").datebox('getValue');  
        //var dateto = $('#checkdateto').datebox('getValue');  
         
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.DHCINCMaterialAudit",
            QueryName:"GetList" ,   
             hospid:HospId,         
            'code':code,    
            'desc': desc, 
            'audit':audit /* ,
            'datefrom':datefrom,
            'dateto':dateto */
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#TextCode").val("");
        $("#TextDesc").val(""); 
        $('#TextBDPINCAAudit').combobox('setValue','');
        var date=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDefaultDate");
        var titlenamearr=date.split("^");
       // $("#checkdatefrom").datebox('setValue',titlenamearr[0]); 
        //$('#checkdateto').datebox('setValue', titlenamearr[1]);
        
        
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.DHCINCMaterialAudit",
            QueryName:"GetList", 
            hospid:HospId
        });
        $('#mygrid').datagrid('unselectAll');
    } 
    
    /// 新增材料的按钮
    function AddINCItmData(){ 
        $('#INCItm-form-save').form("clear"); //优化弹窗清空   
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green"); 
        $HUI.checkbox("#Charge").setValue(true);        
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
                    SaveINCFunLib("");
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
        onSelect:function(ind,item){console.log(item);}, 
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
    
    
    /// 新增 库存项 
    function SaveINCFunLib(procInsId){
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
         
        $.messager.confirm('提示', "确认要保存数据吗?", function(r){
            if (r){
                $('#INCItm-form-save').form('submit', { 
                    url: INC_SAVE_ACTION_URL, 
                    onSubmit: function(param){ 
                         param.ID = procInsId;
                         param.LinkHospId = HospId;
                    },
                    success: function (data) {   
                        var data=eval('('+data+')'); 
                        if (data.success == 'true') { 
                            $.messager.popover({msg: '提交成功！',type:'success',timeout: 1000}); 
                            $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                            $('#mygrid').datagrid('unselectAll');
                            $('#myWin').dialog('close'); // close a dialog
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
       
     /// 查看数据进度条
   function CheckJDTData(){
       var record = mygrid.getSelected(); 
       if (record){           
             var BDPINCAProcInsId = record.BDPINCAProcInsId;  
             var link="https://111.205.6.203:8005/bpm/process/inst/trace/"+BDPINCAProcInsId; 
             var link=encodeURI(link)
             var content='<iframe id="iframsort" src=" '+link+' " width="100%" height="100%"></iframe>';  
             var LookLifeWin = $HUI.dialog("#LookLifeWin",{
                    resizable:true,
                    title:'查看审批进度',
                    width:1400,
                    height:650,
                    modal:true ,
                    autoScroll:false,
                    content :content  
             });  
       }
       else{ 
           // $.messager.alert('操作提示',"请选择一行数据！","error");
       }
   }  
   
   /// 数据驳回后拟稿签收提交给物价办 
   /*
   function SubmitINCItmData(){
        var record = mygrid.getSelected(); 
       if (record){           
            var procInsId = record.BDPINCAProcInsId;   
            $('#INCItm-form-save').form("clear"); //优化弹窗清空   
            $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green"); 
            //$HUI.checkbox("#Charge").setValue(true);       
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
                            SaveINCFunLib(procInsId);
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
                onSelect:function(ind,item){console.log(item);}, 
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
              
              
         }  else{ 
        
       }
      
   }
   */
  
    //var date=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDefaultDate");
    //var titlenamearr=date.split("^");
    //$("#checkdatefrom").datebox('setValue',titlenamearr[0]); 
    //$('#checkdateto').datebox('setValue', titlenamearr[1]); 
};
$(init);
