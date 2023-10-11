/// Function:HOS人员基本信息
///	Creator: gaoshanshan
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSPerson&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSPerson";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSPerson&pClassMethod=DeleteData";

var init = function(){
    var URL_Icon="../scripts/bdp/Framework/icons/";
    //照片上传
    $('#btnUpload').click(function () { 
    	var ID=""
    	var record = $("#mygrid").datagrid("getSelected"); 
    	if (record){
    		ID=record.ID
    	}
    	var repUrl="dhc.bdp.ct.uploadphoto.csp"; 
    	if ("undefined"!==typeof websys_getMWToken){
			repUrl += "?MWToken="+websys_getMWToken()
		}
		$("#myWinUpload").show();  
		var myWinUpload = $HUI.dialog("#myWinUpload",{
			resizable:true,
			title:'照片上传',
			modal:true,
			content:'<iframe  frameborder="0" src='+repUrl+' width="100%" height="99%"></iframe>',
			onClose:function(){
				if($("#PAPhoto").val()!=""){
					$("#PhotoImg").attr("src",$("#PAPhoto").val())
				}else{
					$("#PhotoImg").attr("src",'../scripts/bdp/Framework/imgs/null.jpg')
				}
			}
		});
    })
     //失焦事件
     $('#PAName').bind('blur',function(){
          var PAName=$("#PAName").val()  
          var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetDBCCNCODE",PAName,4) 
          var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",PAName,1) 
          $("#PAPYCode").val(PYCode)
          $("#PAWBCode").val(WBCode)                                           
      });
    //性别
    $("#PAGenderCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.CTSex&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTSEXRowId',
	    textField: 'CTSEXDesc'
	})
	//国籍 
	$("#PANationalityCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.CTCountry&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTCOURowId',
	    textField: 'CTCOUDesc'
	})
	//第一语言
	$("#PALanguageCode1").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.SSLanguage&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTLANRowId',
	    textField: 'CTLANDesc'
	})
	//第二语言
	$("#PALanguageCode2").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.SSLanguage&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTLANRowId',
	    textField: 'CTLANDesc'
	})
	//证件类型 
	$("#PAIdentityType").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.DHCCredType&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CRTRowID',
	    textField: 'CRTDesc'
	})
	//民族 
	$("#PANationCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.CTNation&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTNATRowId',
	    textField: 'CTNATDesc'
	})
	//学历 
	$("#PAEducationCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.CTEducation&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'EDURowId',
	    textField: 'EDUDesc'
	})
	//学位 
	$("#PADegreeCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.HOSDegree&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'ID',
	    textField: 'DEGDesc'
	})
	//职业 
	$("#PAOccupationCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.CTOccupation&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTOCCRowId',
	    textField: 'CTOCCDesc'
	})
	//婚姻 
	$("#PAMarriedCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.CTMarital&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTMARRowId',
	    textField: 'CTMARDesc'
	})
	//宗教 
	$("#PAReligionCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.CTReligion&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTRLGRowId',
	    textField: 'CTRLGDesc'
	})
	//籍贯（国家）
	$("#PANPCountryCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.CTCountry&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTCOURowId',
	    textField: 'CTCOUDesc',
	    placeholder:'国家',
	    onSelect:function(record){
	    	 $('#PANPPROVCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTProvince&QueryName=GetDataForCmb1&ResultSetType=array&countrydr="+record.CTCOURowId);
	    	 $('#PANPPROVCode').combobox('setValue',"");
	    	 $('#PANPCITYCode').combobox('loadData',{});
	    	 $('#PANPCITYCode').combobox('setValue',"");
	    	 $('#PANPDISTRCode').combobox('loadData',{});
	    	 $('#PANPDISTRCode').combobox('setValue',"");
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue==""){
				$('#PANPPROVCode').combobox('loadData',{});
				$('#PANPPROVCode').combobox('setValue',"");
				$('#PANPCITYCode').combobox('loadData',{});
				$('#PANPCITYCode').combobox('setValue',"");
				$('#PANPDISTRCode').combobox('loadData',{});
				$('#PANPDISTRCode').combobox('setValue',"");
	    		
	    	}
	    }
	})
	//籍贯（省）
	$("#PANPPROVCode").combobox({
	    //url:$URL+"?ClassName=web.DHCBL.CT.CTProvince&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'PROVRowId',
	    textField: 'PROVDesc',
	    placeholder:'省',
	    onSelect:function(record){
	    	$('#PANPCITYCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTCity&QueryName=GetDataForCmb1&ResultSetType=array&provincedr="+record.PROVRowId);
	    	$('#PANPCITYCode').combobox('setValue',"");
	    	$('#PANPDISTRCode').combobox('loadData',{});
	    	$('#PANPDISTRCode').combobox('setValue',"");
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue==""){
	    		$('#PANPCITYCode').combobox('loadData', {});
		    	$('#PANPCITYCode').combobox('setValue',"");
		    	$('#PANPDISTRCode').combobox('loadData',{});
		    	$('#PANPDISTRCode').combobox('setValue',"");
	    	}
	    }
	})
	//籍贯（市）
	$("#PANPCITYCode").combobox({
	    //url:$URL+"?ClassName=web.DHCBL.CT.CTCity&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTCITRowId',
	    textField: 'CTCITDesc',
	    placeholder:'市',
	    onSelect:function(record){
	    	$('#PANPDISTRCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTCityArea&QueryName=GetDataForCmb1&ResultSetType=array&citydr="+record.CTCITRowId);
	    	$('#PANPDISTRCode').combobox('setValue',"");
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue==""){
		    	$('#PANPDISTRCode').combobox('loadData',{});
		    	$('#PANPDISTRCode').combobox('setValue',"");
	    	}
	    }
	})
	//籍贯（县区）
	$("#PANPDISTRCode").combobox({
	    //url:$URL+"?ClassName=web.DHCBL.CT.CTCityArea&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CITAREARowId',
	    textField: 'CITAREADesc',
	    placeholder:'县区'
	})
	//现住址（国家）
	$("#PAAddrCountryCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.CTCountry&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTCOURowId',
	    textField: 'CTCOUDesc',
	    placeholder:'国家',
	    onSelect:function(record){
	    	$('#PAAddrPROVCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTProvince&QueryName=GetDataForCmb1&ResultSetType=array&countrydr="+record.CTCOURowId);
	    	$('#PAAddrPROVCode').combobox('setValue',"");
	    	$('#PAAddrCITYCode').combobox('setValue',"");
	    	$('#PAAddrDISTRCode').combobox('setValue',"");
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue==""){
	    		$('#PAAddrPROVCode').combobox('loadData',{});
	    		$('#PAAddrPROVCode').combobox('setValue',"");
	    		$('#PAAddrCITYCode').combobox('loadData',{});
	    		$('#PAAddrCITYCode').combobox('setValue',"");
	    		$('#PAAddrDISTRCode').combobox('loadData',{});
	    		$('#PAAddrDISTRCode').combobox('setValue',"");
	    	}
	    }
	})
	//现住址（省）
	$("#PAAddrPROVCode").combobox({
	    //url:$URL+"?ClassName=web.DHCBL.CT.CTProvince&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'PROVRowId',
	    textField: 'PROVDesc',
	    placeholder:'省',
	    onSelect:function(record){
	    	$('#PAAddrCITYCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTCity&QueryName=GetDataForCmb1&ResultSetType=array&provincedr="+record.PROVRowId);
	    	$('#PAAddrCITYCode').combobox('setValue',"");
	    	$('#PAAddrDISTRCode').combobox('loadData',{});
	    	$('#PAAddrDISTRCode').combobox('setValue',"");
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue==""){
	    		$('#PAAddrCITYCode').combobox('loadData',{});
	    		$('#PAAddrCITYCode').combobox('setValue',"");
	    		$('#PAAddrDISTRCode').combobox('loadData',{});
	    		$('#PAAddrDISTRCode').combobox('setValue',"");
	    	}
	    }
	})
	//现住址（市）
	$("#PAAddrCITYCode").combobox({
	    //url:$URL+"?ClassName=web.DHCBL.CT.CTCity&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTCITRowId',
	    textField: 'CTCITDesc',
	    placeholder:'市',
	    onSelect:function(record){
	    	$('#PAAddrDISTRCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTCityArea&QueryName=GetDataForCmb1&ResultSetType=array&citydr="+record.CTCITRowId);
	    	$('#PAAddrDISTRCode').combobox('setValue',"");
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue==""){
	    		$('#PAAddrDISTRCode').combobox('loadData',{});
	    		$('#PAAddrDISTRCode').combobox('setValue',"");
	    	}
	    }
	})
	//现住址（县区）
	$("#PAAddrDISTRCode").combobox({
	    //url:$URL+"?ClassName=web.DHCBL.CT.CTCityArea&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CITAREARowId',
	    textField: 'CITAREADesc',
	    placeholder:'县区'
	})
	//状态 CT.BDP.CT.HOSPersonStatusDict
	$("#PAPersonStatus").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.HOSPersonStatusDict&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'ID',
	    textField: 'PSDDesc'
	})
    var columns =[[  
                  {field:'PAPersonID',title:'标识码',width:300,sortable:true},
                  {field:'EMPPAPersonNo',title:'工号',width:160,sortable:true}, 
                  {field:'PAName',title:'姓名',width:180,sortable:true}, 
                  {field:'PAFormerName',title:'曾用名',width:180,sortable:true,hidden:true}, 
                  {field:'PAGenderDesc',title:'性别',width:120,sortable:true}, 
                  {field:'PABirthDate',title:'出生日期',width:180,sortable:true}, 
                  {field:'PABirthTime',title:'出生时间',width:180,sortable:true,hidden:true},  
                  {field:'PANationalityDesc',title:'国籍',width:180,sortable:true,hidden:true},  
                  {field:'PANationDesc',title:'民族',width:120,sortable:true},  
                  {field:'PAEducationDesc',title:'学历',width:180,sortable:true,hidden:true},  
                  {field:'PADegreeDesc',title:'学位',width:180,sortable:true,hidden:true},  
                  {field:'PAOccupationDesc',title:'职业',width:180,sortable:true,hidden:true},  
                  {field:'PAMarriedDesc',title:'婚姻',width:180,sortable:true,hidden:true},  
                  {field:'PAReligionDesc',title:'宗教',width:180,sortable:true,hidden:true},  
                  {field:'PANP',title:'籍贯',width:180,sortable:true,hidden:true},  
                  {field:'PAAddr',title:'现住址',width:180,sortable:true,hidden:true},  
                  {field:'PAAddress',title:'详细地址',width:180,sortable:true,hidden:true},  
                  {field:'PAMobile',title:'手机号码',width:180,sortable:true,hidden:true},  
                  {field:'PAPersonStatusDesc',title:'状态',width:180,sortable:true},  
                  {field:'PAActivity',title:'是否有效',align:'center',width:120,sortable:true,formatter:ReturnFlagIcon},  
                  {field:'PAStartDate',title:'开始日期',width:180,sortable:true},  
                  {field:'PAEndDate',title:'结束日期',width:180,sortable:true},  
                  {field:'PASeqNo',title:'排序号',width:120,sortable:true},  
                  {field:'PAPYCode',title:'拼音码',width:180,sortable:true},  
                  {field:'PAWBCode',title:'五笔码',width:180,sortable:true},  
                  {field:'PAMark',title:'备注',width:120,sortable:true},  
                  {field:'ID',title:'ID',hidden:true}
                  ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.CT.HOSPerson",
            QueryName:"GetList"
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.HOSPerson',
        SQLTableName:'CT_BDP_CT.HOS_Person',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300], 
        singleSelect:true,
        idField:'ID', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
		}
    });
    
   //搜索回车事件
	$('#TextDesc,#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
	});  
	//状态查询框 CT.BDP.CT.HOSPersonStatusDict
	$("#TextStatus").combobox({
	    //url:$URL+"?ClassName=web.DHCBL.CT.HOSPersonStatusDict&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'ID',
	    textField: 'PSDDesc',
	    onShowPanel:function(){
	    	$('#TextStatus').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.HOSPersonStatusDict&QueryName=GetDataForCmb1&ResultSetType=array")
	    },
	    onSelect:function(){
	    	SearchFunLib();
	    }
	})
    //查询按钮
    $("#btnSearch").click(function (e) { 
         SearchFunLib();
     })  
     
    //重置按钮
    $("#btnRefresh").click(function (e) { 
         ClearFunLib();
     })  
	
	//点击添加按钮
	$("#btnAdd").click(function(e){
		AddData();
	});
	//点击修改按钮
	$("#btnUpdate").click(function(e){
		UpdateData();
	});
	//点击删除按钮
	$("#btnDel").click(function (e) { 
		DeleteData();
	});	
	
     //查询方法
    function SearchFunLib(){
        var code=$.trim($("#TextCode").val());
        var desc=$.trim($('#TextDesc').val());
        var status=$("#TextStatus").combobox('getValue');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSPerson",
            QueryName:"GetList" ,   
            'code':code,    
            'desc':desc,
            'status':status
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#TextCode").val("");
        $("#TextDesc").val("");
        $("#TextStatus").combobox('setValue',"");
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSPerson",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
     //点击新增按钮
    function AddData() { 
    	$('#PAGenderCode,#PANationalityCode,#PALanguageCode1,#PALanguageCode2,#PAIdentityType,#PANationCode,#PAEducationCode,#PADegreeCode,#PAOccupationCode,#PAMarriedCode,#PAReligionCode').combobox('reload');
		$('#PANPCountryCode,#PAAddrCountryCode,#PAPersonStatus').combobox('reload');
		$('#PANPPROVCode,#PANPCITYCode,#PANPDISTRCode').combobox('loadData',{});
		$('#PAAddrPROVCode,#PAAddrCITYCode,#PAAddrDISTRCode').combobox('loadData',{});
		
    	$('#form-save').form("clear"); 
        $("#PhotoImg").attr("src",'../scripts/bdp/Framework/imgs/null.jpg')
        $HUI.checkbox("#PAActivity").setValue(true);
        $('#PAStartDate').datebox('setValue', getCurentDateStr());
        
        $("#myWin").show(); 
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存',
                //iconCls:'icon-save',
                id:'save_btn',
                handler:function(){
                    SaveFunLib("");
                }
            },{
                text:'关闭',
                //iconCls:'icon-cancel',
                handler:function(){
                    myWin.close();
                }
            }]
        });  
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
    }
 

    //点击修改按钮
    function UpdateData() {
        var record = mygrid.getSelected(); 
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.HOSPerson",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
                $('#form-save').form("load",jsonData);  
                if(jsonData.PAPhoto!=""){
					$("#PhotoImg").attr("src",jsonData.PAPhoto)
				}else{
					$("#PhotoImg").attr("src",'../scripts/bdp/Framework/imgs/null.jpg')
				}
				if(jsonData.PAActivity=="Y"){
					$HUI.checkbox("#PAActivity").setValue(true);
				}else{
					$HUI.checkbox("#PAActivity").setValue(false);
				}
				//籍贯 省 市 县区 重新加载
				if(jsonData.PANPCountryCode!="") $('#PANPPROVCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTProvince&QueryName=GetDataForCmb1&ResultSetType=array&countrydr="+jsonData.PANPCountryCode);
				if(jsonData.PANPPROVCode!="") $('#PANPCITYCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTCity&QueryName=GetDataForCmb1&ResultSetType=array&provincedr="+jsonData.PANPPROVCode);
				if(jsonData.PANPCITYCode!="") $('#PANPDISTRCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTCityArea&QueryName=GetDataForCmb1&ResultSetType=array&citydr="+jsonData.PANPCITYCode);
            
            	//现住址 省 市 县区 重新加载
				if(jsonData.PAAddrCountryCode!="") $('#PAAddrPROVCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTProvince&QueryName=GetDataForCmb1&ResultSetType=array&countrydr="+jsonData.PAAddrCountryCode);
				if(jsonData.PAAddrPROVCode!="") $('#PAAddrCITYCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTCity&QueryName=GetDataForCmb1&ResultSetType=array&provincedr="+jsonData.PAAddrPROVCode);
				if(jsonData.PAAddrCITYCode!="") $('#PAAddrDISTRCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTCityArea&QueryName=GetDataForCmb1&ResultSetType=array&citydr="+jsonData.PAAddrCITYCode);

            });
                     
            $("#myWin").show(); 
            $('#PAGenderCode,#PANationalityCode,#PALanguageCode1,#PALanguageCode2,#PAIdentityType,#PANationCode,#PAEducationCode,#PADegreeCode,#PAOccupationCode,#PAMarriedCode,#PAReligionCode').combobox('reload');
			$('#PANPCountryCode,#PAAddrCountryCode,#PAPersonStatus').combobox('reload');
            var myWin = $HUI.dialog("#myWin",{
                iconCls:'icon-w-edit',
                resizable:true,
                title:'修改',
                modal:true,
                buttons:[{
                    text:'保存',
                    //iconCls:'icon-save',
                    id:'save_btn',
                    handler:function(){
                    	SaveFunLib(id);
                    }
                },{
                    text:'关闭',
                    //iconCls:'icon-cancel',
                    handler:function(){
                        myWin.close();
                    }
                }]
            });  
            $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green"); 
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
	
    ///新增、更新
    function SaveFunLib(id)
    {            
        var code=$.trim($("#PAPersonID").val());
        var desc=$.trim($("#PAName").val());
        var datefrom=$("#PAStartDate").datebox("getValue");
        var dateto=$("#PAEndDate").datebox("getValue");
        if (code=="")
        {
            $.messager.alert('错误提示','标识码不能为空!',"error");
            return;
        }
        if (desc=="")
        {
            $.messager.alert('错误提示','姓名不能为空!',"error");
            return;
        }
		if (datefrom=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return;
        }
		if (datefrom != "" && dateto != "") {   
        	if (datefrom >dateto) {
        		$.messager.alert('错误提示','开始日期不能大于结束日期!',"error"); 
          		return;
      		}
   		}
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL, 
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

    ///删除
    function DeleteData()
    {    
        //更新
        var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        } 
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				var rowid=row.ID; 
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {  
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
								$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
								$('#mygrid').datagrid('unselectAll');
							  } 
							  else { 
								var errorMsg ="删除失败！"
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
    HISUI_Funlib_Translation('mygrid');
    HISUI_Funlib_Sort('mygrid'); 
    
    var windowHight = document.documentElement.clientHeight;        //可获取到高度
    var windowWidth = document.documentElement.clientWidth;
    
    //点击组织按钮
	$("#btnEmployee").click(function (e) { 
		var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        } 
		$("#myWinEmployee").show(); 
		var url="dhc.bdp.ct.hosorgemployee.csp?personid="+row.ID
		if ("undefined"!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		var myWinEmployee = $HUI.dialog("#myWinEmployee",{
			resizable:true,
			title:row.PAName+'-组织',
			width: windowWidth-50,    
            height: windowHight-20,
			modal:true,
			draggable :true,
			content:"<iframe scrolling='auto' frameborder='0' width='100%' height='100%' src='"+url+"'></iframe>"
		})
	});	
    //点击职位按钮
	$("#btnPostion").click(function (e) { 
		var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        } 
		$("#myWinPostion").show(); 
		var url="dhc.bdp.ct.hosemppostion.csp?personid="+row.ID
		if ("undefined"!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		var myWinPostion = $HUI.dialog("#myWinPostion",{
			resizable:true,
			title:row.PAName+'-职位',
			width: windowWidth-50,    
            height: windowHight-20,
			modal:true,
			draggable :true,
			content:"<iframe scrolling='auto' frameborder='0' width='100%' height='100%' src='"+url+"'></iframe>"
		})
	});	
	//点击职务按钮
	$("#btnProfTitle").click(function (e) { 
		var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        } 
		$("#myWinProfTitle").show();  
		var url="dhc.bdp.ct.hosempproftitle.csp?personid="+row.ID
		if ("undefined"!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		var myWinProfTitle = $HUI.dialog("#myWinProfTitle",{
			resizable:true,
			title:row.PAName+'-职务',
			width: windowWidth-50,    
            height: windowHight-20,
			modal:true,
			draggable :true,
			content:"<iframe scrolling='auto' frameborder='0' width='100%' height='100%' src='"+url+"'></iframe>"
		})
	});	
	//点击岗位按钮
	$("#btnPost").click(function (e) { 
		var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        } 
		$("#myWinPost").show();  
		var url="dhc.bdp.ct.hosemppost.csp?personid="+row.ID
		if ("undefined"!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		var myWinPost = $HUI.dialog("#myWinPost",{
			resizable:true,
			title:row.PAName+'-岗位',
			width: windowWidth-50,    
            height: windowHight-20,
			modal:true,
			draggable :true,
			content:"<iframe scrolling='auto' frameborder='0' width='100%' height='100%' src='"+url+"'></iframe>"
		})
	});	
};
$(init);