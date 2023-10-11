//手术切口调查表[Event]
function InitRepSurvWinEvent(obj) {
	//管理员权限
	var CheckFlg = 0;
    if (tDHCMedMenuOper['Admin'] == 1) {
        CheckFlg = 1; //审核权限
    }
    //初始化
    obj.LoadEvent=function(){
		//加载表格
		obj.refreshOprQry();
	}
	//院区点击事件
    $HUI.combobox('#cboHospital', {
    	onSelect: function (data) {
	    	obj.cboLoction = Common_ComboToLoc('cboLoction',data.ID);	//初始化手术科室
    		
    		//非管理员(临床不允许修改院区+科室)
			if(CheckFlg!=1){
				$('#cboHospital').combobox('setValue',$.LOGON.HOSPID);	
				$('#cboHospital').combobox('setText',$.LOGON.HOSPDESC);
				$('#cboHospital').combobox('disable');
			
				$('#cboLoction').combobox('setValue',$.LOGON.LOCID);
				$('#cboLoction').combobox('setText',$.LOGON.LOCDESC);
				$('#cboLoction').combobox('disable');
			}
  		}
 	});
	//查询
    $('#btnQuery').click(function (e) {
        obj.refreshOprQry();
    });
    //导出事件
    $('#btnExport').on('click', function () {
		var rows = $('#gridINFOPSQry').datagrid('getRows');//返回当前页的所有行
        if(rows.length==0){
	        $.messager.alert("错误","无记录数据,不允许导出!", 'info');
			return;
	    }
        $('#gridINFOPSQry').datagrid('toExcel', '手术切口调查表.xls');   //导出
    });
    //检索框
    $('#searchbox').searchbox({
        searcher: function (value, name) {
	        if(value=="") {
		       $('#btnQuery').click();
		    } else {
			    searchText($("#gridINFOPSQry"), value);
			}           
        }
    });
    	//获取弹窗方式 0为窗口 1为csp
	obj.flg = $m({
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"IsShowModal"
		},false);
	//获取当前页面的缩放值
	function detectZoom() {
		var ratio = 1;
		if(BrowserVer=="isChrome") {   //医为浏览器为 Chrome 49
			var userAgent = navigator.userAgent;
            var ChromePos = userAgent.indexOf("Chrome");  //Chrome定位
            var ChromeStr = userAgent.substr(ChromePos);  //Chrome串
            var ChromeArr = ChromeStr.split(" ");
            var ChromeVer = parseInt(ChromeArr[0].split("/")[1]);      //Chrome版本
			if (ChromeVer<=58) {    
				ratio = window.devicePixelRatio;
			}
		}
		return ratio;
	}
    //摘要
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
		var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
	  	var ratio =detectZoom();
        var PageWidth=Math.round(1320*ratio);
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:'医院感染集成视图',
				iconCls:'icon-w-epr',
				closable:true,
				width:PageWidth,
				height:'95%',
			});
		}
		else{
			var Page=DHCCPM_Open(strUrl);
		}   
	};
   
    //刷新表
    obj.refreshOprQry = function () {
        var HospID = $('#cboHospital').combobox('getValue');		//院区
		var DateType = $('#cboDateType').combobox('getValue');		//日期类型
        var DateFrom = $('#dtDateFrom').combobox('getValue');		//开始日期
        var DateTo = $('#dtDateTo').combobox('getValue');			//结束日期
		var OperCat  = $('#cboOperCat').combobox('getValues').toString(",");			//手术分类
        var CuteType = $('#cboIncision').combobox('getValue');		//切口等级
       	var OprLocID = $('#cboLoction').combobox('getValue');		//手术科室
		var VisitRes = $('#cboVisitResult').combobox('getValue');	//回访结果
		var SurvStatus = $('#cboSurvStatus').combobox('getValue');	//报告状态
		if (DateType == "") {
            $.messager.alert("提示", "日期类型不能为空!", 'info');
            return;
        }
		if (DateFrom == "") {
            $.messager.alert("提示", "开始日期不能为空!", 'info');
            return;
        }
        if (DateTo == "") {
            $.messager.alert("提示", "结束日期不能为空!", 'info');
            return;
        }
        if (Common_CompareDate(DateFrom, Common_GetDate(new Date())) == 1) {
            $.messager.alert("提示", "开始日期不能大于当前日期!", 'info');
            return;
        }
		if (Common_CompareDate(DateFrom, DateTo) == 1) {
            $.messager.alert("提示", "开始日期不能大于结束日期!", 'info');
            return;
        }
        
        $("#gridINFOPSQry").datagrid("loading");
        var Ret = $cm({
			ClassName:"DHCHAI.DPS.OROperAnaesSrv",
			QueryName:"QryINFOPSSurv",
			aDateFrom: DateFrom,
            aDateTo: DateTo,
            aLocID: OprLocID,
            aHospID: HospID,
            aCuteType: CuteType,
            aEpisodeID: "",
            aVisitRes:VisitRes,
            aDateType:DateType,
			aOperCat:OperCat,
			aSurvStatus:SurvStatus,
            page: 1,
            rows: 99999
        }, function (rs) {
            $('#gridINFOPSQry').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
		//存储临时入参
		obj.tempHospID=HospID;
		obj.tempDateType=DateType;
		obj.tempDateFrom=DateFrom;
		obj.tempDateTo=DateTo;
		obj.tempOperCat=OperCat;
		obj.tempCuteType=CuteType;
		obj.tempOprLocID=OprLocID;
		obj.tempVisitRes=VisitRes;
    }
     //打开手术切口调查表
    obj.OpenOprReport = function (index) {
	    //选中行数据
        $('#gridINFOPSQry').datagrid('selectRow', index);
        var row = $('#gridINFOPSQry').datagrid('getSelected');
		var ratio =detectZoom();
        //var PageWidth=Math.round(1350*ratio);
        var PageWidth=1350;
		var url = "dhcma.hai.ir.opr.report.csp?Admin=1"+ '&OpsID=' + row.INFOPSID + '&ReportID=' + row.ReportID +'&OperAnaesID='+row.ID+'&EpisodeID=' + row.EpisodeDr+ "&5=5";
		if(obj.flg=="1"){
		websys_showModal({
            url: url,
            title: '手术切口调查表',
            iconCls: 'icon-w-epr',
            closable: true,
            width: PageWidth,
            height: '95%',
            onBeforeClose: function () {
              	//取row.ID对应行数据
				var OperDataList = $cm({
            		ClassName:'DHCHAI.DPS.OROperAnaesSrv',
					QueryName:'QryINFOPSSurv',
					aDateFrom: obj.tempHospID,
            		aDateTo: obj.tempDateTo,
            		aLocID: obj.tempOprLocID,
            		aHospID: obj.tempHospID,
            		aCuteType: obj.tempCuteType,
            		aVisitRes:obj.tempVisitRes,
            		aDateType:obj.tempDateType,
					aOperCat:obj.tempOperCat,
					aEpisodeID:"",
					aOperAnaesID:row.ID,
					page:1,
					rows:200
       			}, false);
       			var OperData = OperDataList.rows[0];
       			//刷新行
				if(OperData!=""){
					$('#gridINFOPSQry').datagrid('updateRow', {
						index: index,
            			row: {
        					"ID":OperData.ID,
        					"EpisodeDr":OperData.EpisodeDr,
        					"ReportID":OperData.ReportID,
	            			"INFOPSID":OperData.INFOPSID,
							"RepStatus":OperData.RepStatus,
							"OperDesc": OperData.OperDesc,
							"OperCatLists": OperData.OperCatLists,
							"OperLocDesc": OperData.OperLocDesc,
							"OperDate": OperData.OperDate,
							"MapIncDicDesc": OperData.MapIncDicDesc,
							"OperHour": OperData.OperHour,
							"OpertorName": OperData.OpertorName,
							"MapTypeDicDesc": OperData.MapTypeDicDesc,
							"MapASADicDesc": OperData.MapASADicDesc,
							"AdmDate": OperData.AdmDate,
							"DischDate": OperData.DischDate,
							"InLocDate": OperData.InLocDate,
							"OutLocDate": OperData.OutLocDate,
							"RepUser": OperData.RepUser,
							"RepDate": OperData.RepDate,
							"VistDate": OperData.VistDate,
							"VisitResult": OperData.VisitResult,
						}
					});
				}
            }
        });}
		else{
			var page= websys_createWindow(url,"","width="+PageWidth+",height=95%");
			//--关闭前刷新查询列表
			var Loop=setInterval(function() {     
			 if(page.closed) {   	
				 clearInterval(Loop);
				//取row.ID对应行数据
				var OperDataList = $cm({
            		ClassName:'DHCHAI.DPS.OROperAnaesSrv',
					QueryName:'QryINFOPSSurv',
					aDateFrom: obj.tempHospID,
            		aDateTo: obj.tempDateTo,
            		aLocID: obj.tempOprLocID,
            		aHospID: obj.tempHospID,
            		aCuteType: obj.tempCuteType,
            		aVisitRes:obj.tempVisitRes,
            		aDateType:obj.tempDateType,
					aOperCat:obj.tempOperCat,
					aEpisodeID:"",
					aOperAnaesID:row.ID,
					page:1,
					rows:200
       			}, false);
       			var OperData = OperDataList.rows[0];
       			//刷新行
				if(OperData!=""){
					$('#gridINFOPSQry').datagrid('updateRow', {
						index: index,
            			row: {
        					"ID":OperData.ID,
        					"EpisodeDr":OperData.EpisodeDr,
        					"ReportID":OperData.ReportID,
	            			"INFOPSID":OperData.INFOPSID,
							"RepStatus":OperData.RepStatus,
							"OperDesc": OperData.OperDesc,
							"OperCatLists": OperData.OperCatLists,
							"OperLocDesc": OperData.OperLocDesc,
							"OperDate": OperData.OperDate,
							"MapIncDicDesc": OperData.MapIncDicDesc,
							"OperHour": OperData.OperHour,
							"OpertorName": OperData.OpertorName,
							"MapTypeDicDesc": OperData.MapTypeDicDesc,
							"MapASADicDesc": OperData.MapASADicDesc,
							"AdmDate": OperData.AdmDate,
							"DischDate": OperData.DischDate,
							"InLocDate": OperData.InLocDate,
							"OutLocDate": OperData.OutLocDate,
							"RepUser": OperData.RepUser,
							"RepDate": OperData.RepDate,
							"VistDate": OperData.VistDate,
							"VisitResult": OperData.VisitResult,
						}
					});
				}
				 }
				});
		}
	}
	//分类
	$('#btnOper').on('click', function () {
		var rows =  $('#gridINFOPSQry').datagrid('getSelected');
        if(!rows){
			$.messager.alert("提示","先选择某一行再执行分类!", 'info');
			return;
	    }else {
		    var OperType=rows.OperTypeSoC;
			var OperCatDrs=rows.OperCatDrs;
			var OperCatLists=rows.OperCatLists;
			$('#cboIsAll').combobox('clear');
			
			$('#OperCatEdit').show();
			obj.OperCatEdit();
			if (OperType=="N") OperType="I";
			if (OperType=="T") OperType="D";
			if (OperType) {
				$('#cboOperType').combobox('setValue',OperType);
			}else {
				$('#cboOperType').combobox('clear');
			}
			
			$HUI.combobox("#OperCat",{
				url:$URL+'?ClassName=DHCHAI.IRS.CRuleOperCatSrv&QueryName=QryCRuleOperCat&ResultSetType=Array&aIsActive=1',
				allowNull: true,       //再次点击取消选中
				editable: true,
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				valueField:'ID',
				textField:'OperCat',
				onSelect:function(rd){
					if (rd) {
						$('#cboOperType').combobox('setValue',rd.OperType);
					}
				}
			});
			if (OperCatDrs) {
				var arrOperCat=OperCatDrs.split(",");
				$('#OperCat').combobox('setValues',arrOperCat);
			}else {
				$('#OperCat').combobox('clear');
			}
		}
        
    });
	
	//窗体初始化
	obj.OperCatEdit =function() {
		$('#OperCatEdit').dialog({
			title: '手术分类编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	}
	
	$('#btnClose').on('click', function(){
		$HUI.dialog('#OperCatEdit').close();
	});
	
	//保存
	$('#btnSave').on('click', function(){	
		var rows =  $('#gridINFOPSQry').datagrid('getSelected');	
		var ID          = rows.ID;
		var OperDesc    = rows.OperDesc;
		var OperCatIDs  = $('#OperCat').combobox('getValues').toString(",");
		var OperCat     = $('#OperCat').combobox('getText');
		var OperType    = $('#cboOperType').combobox('getValue');
		var IsAll       = $('#cboIsAll').combobox('getValue');
		var ActUser     = $.LOGON.USERID;
		if (!OperCat) {
			$.messager.alert("错误提示", "请先选择或编辑手术分类！" , 'info');	
			return;	
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
			MethodName:"OprAnaesOperCat",
			aID:ID,
			aOperDesc:OperDesc,
			aCatIDs:OperCatIDs,
			aOperCat:OperCat,
			aOperType:OperType,
			aIsAll:IsAll,
			aActUser:ActUser
		},false);
		
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "分类失败" , 'info');	
			return;	
		}else {
			$HUI.dialog('#OperCatEdit').close();
			$.messager.popover({msg: '分类成功！',type:'success',timeout: 1000});
			obj.refreshOprQry();
		}	
	});
}
