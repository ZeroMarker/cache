//页面Event
function InitHISUIWinEvent(obj){
	//事件绑定
	obj.LoadEvents = function(arguments){
		$("#btnQuery").on('click',function(){
			obj.QryRelateArcims();	
		})
		
		$("#btnReplace").on('click',function(){
			obj.SaveReplaceArcimInfo();	
		})
		
		$("#btnAddPos").on('click',function(){
			obj.IconAddChkPos();
		});
	}
	
	//查询已关联医嘱
	obj.QryRelateArcims = function(){
		var pathTypeID = $("#cboPathType").combobox("getValue");
		var selArcimID = $("#txtSelArcims").lookup("getValue");
		var hospID = $("#cboHosp").combobox("getValue");
		
		if(hospID==""||hospID==undefined)
		{
			$.messager.popover({msg: '请选择要查询的院区！',type:'error'});
			return false;
		}

		if(selArcimID==""||selArcimID==undefined)
		{
			$.messager.popover({msg: '请选择要查询的关联医嘱！',type:'error'});
			return false;
		}
		
		$cm({
			ClassName:"DHCMA.CPW.BTS.BatHandleOrd",
			QueryName:"QryRelPathOrds",
			aPathTypeID:pathTypeID,
			aArcimID:selArcimID,
			aHospID:hospID
		},function(rs){
			$('#gridRelateArcim').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
		})
			
	}
	
	// 替换医嘱信息取默认值赋值
	obj.OrdMastSelect=function(rowData)
	{
		//取医嘱项相关信息赋值
		//691||1^R^1^1^17^支^63^1天^4^Qd^4^注射^46^注射用无菌粉末^632^注射用奥美拉唑钠^[40mg]^17^支^注射用奥美拉唑钠[利君][40mg]
		var rstData = $cm({ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",MethodName:"GetArcimInfoById",aArcimID:rowData.ArcimID,dataType:'text'},false);
		var rstArr = rstData.split("^");		
		
		//单位赋值	
		obj.cboOrdUOMID = $HUI.combobox("#cboOrdUOMID",{
			url:$URL+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryDoseUomByArcim&aArcimID="+rowData.ArcimID+"&ResultSetType=array",
			valueField:'DoseUomID',
			textField:'DoseUomDesc'
		});
		
		$("#cboOrdFreq").lookup('setValue',rstArr[8]);		//频次
		$("#cboOrdFreq").lookup('setText',rstArr[9]);
		
		$("#cboOrdDurat").lookup('setValue',rstArr[6]);		//疗程
		$("#cboOrdDurat").lookup('setText',rstArr[7]);
		
		$("#cboOrdInstruc").lookup('setValue',rstArr[10]);	//用法
		$("#cboOrdInstruc").lookup('setText',rstArr[11]);
		
		$("#itemOrdGeneID").val(rstArr[14]);  //通用名ID
		$("#txtOrdDoseQty").val(rstArr[3]);  //剂量
		$('#cboOrdUOMID').combobox('setValue',rstArr[4]);
		$("#txtOrdQtyUOMDesc").val(rstArr[18]); //数量单位 dsp
		obj.ARCICOrderType=rstArr[20];	//医嘱类型
	};
	
	//保存替换医嘱
	obj.SaveReplaceArcimInfo = function(){
		var rows = $('#gridRelateArcim').datagrid("getChecked");
		if (rows.length==0){
			$.messager.popover({msg: '未选择任何医嘱！',type:'alert'});	 
			return	
		}
		
		var OrdTypeDr = $("#cboOrdTypeDr").combobox("getValue");
		var OrdMastID = $("#txtOrdMastID").lookup("getValue");
		var OrdGeneID  =$("#itemOrdGeneID").val();							//通用名ID
		var OrdPriorityID = $("#cboOrdPrior").combobox("getValue");			//医嘱类型
		var OrdQty = $("#txtOrdQty").val();									//数量
		var OrdFreqID = $("#cboOrdFreq").lookup("getValue");				//频次
		var OrdDuratID = $("#cboOrdDurat").lookup("getValue");				//疗程
		var OrdInstrucID = $("#cboOrdInstruc").lookup("getValue");			//用法
		var OrdDoseQty = $("#txtOrdDoseQty").val();							//单次剂量
		var OrdUOMID = $("#cboOrdUOMID").combobox("getValue");				//单位
		var OrdNote = $("#txtOrdNote").val();								//医嘱备注
		var OrdChkPosID = $("#txtOrdPos").val();							//检查部位
		var OrdLnkOrdDr =$("#txtOrdLnkOrdDr").val(); 						//关联医嘱
		var OrdOID = "";
		
		if(OrdTypeDr=="")
		{
			$.messager.popover({msg: '分类不可以为空！',type:'error'});
			return false;
		}
		if(OrdMastID==""||OrdMastID==undefined)
		{
			$.messager.popover({msg: '替换医嘱不可以为空！',type:'error'});
			return false;
		}
		if(OrdPriorityID=="")
		{
			$.messager.popover({msg: '医嘱类型不可以为空！',type:'error'});
			return false;
		}
		if((obj.ARCICOrderType=="L")||(obj.ARCICOrderType=="X"))	//检验、检查医嘱
		{
			var TypeDesc=$("#cboOrdPrior").combobox("getText");
			if(TypeDesc!="临时医嘱") {
				$.messager.alert("提示","检查或检验医嘱只能是临时医嘱！");
				return false;
			}
		}
		
		$.messager.confirm("确认","确认将所选关联医嘱全部替换为\""+$("#txtOrdMastID").lookup("getText")+"\"?",function(r){
			if(!r){
				return;	
			}else{
				var tmpStr = OrdTypeDr;
				tmpStr += "^" + OrdMastID;
				tmpStr += "^" + OrdGeneID;
				tmpStr += "^" + OrdPriorityID;
				tmpStr += "^" + OrdQty;
				tmpStr += "^" + OrdFreqID;
				tmpStr += "^" + OrdDuratID;
				tmpStr += "^" + OrdInstrucID;
				tmpStr += "^" + OrdDoseQty;
				tmpStr += "^" + OrdUOMID;
				tmpStr += "^" + OrdNote;
				tmpStr += "^" + OrdChkPosID;
				tmpStr += "^" + OrdLnkOrdDr;
				
				var errInfo="",count=0
				for (var ind = 0; ind < rows.length; ind++){
				//$.each(rows, function(i, item){
					var ParfID = rows[ind].OrdParfID;
					var subID = rows[ind].xFormOrdID.split("||")[3];
					var IsDefault = (rows[ind].OrdIsDefault=='是')?1:0;		//首选医嘱
					var IsFluInfu = (rows[ind].OrdIsFluInfu=='是')?1:0;;	//主医嘱
					var IsActive = (rows[ind].OrdIsActive=='是')?1:0;;		//是否有效
					var OrdOID = rows[ind].OrdOID							//旧系统医嘱
					
					var InputStr=""
					InputStr = ParfID + "^" + subID
					InputStr += "^" + tmpStr
					InputStr += "^" + IsDefault
					InputStr += "^" + IsFluInfu;		
					InputStr += "^" + IsActive;
					InputStr += "^";
					InputStr += "^";
					InputStr += "^" + session['DHCMA.USERID'];
					InputStr += "^" + OrdOID;
					
					//同步调用
					var data = $.cm({ClassName:"DHCMA.CPW.BT.PathFormOrd",MethodName:"Update",
							"aInputStr":InputStr,
							"aSeparete":"^"
						},false);
					if(parseInt(data)<=0){
						count++;
					}			
				}
				
				if (count==0){
					$.messager.popover({msg: '全部替换成功！',type:'success',timeout: 2000});
				}else{
					$.messager.popover({msg: '有'+count+'条数据替换失败！',type:'error',timeout: 2000});
				}
				obj.ClearCmpListVal();
				obj.QryRelateArcims();
				return;	
			}
		})
	}
	
	//清除数据
	obj.ClearCmpListVal = function(){
		$("#cboOrdTypeDr").combobox("clear");
		$("#txtOrdMastID").lookup("setValue","");
		$("#txtOrdMastID").lookup("setText","");
		$("#itemOrdGeneID").val('');							//通用名ID
		$("#cboOrdPrior").combobox("clear");			//医嘱类型
		$("#txtOrdQty").val('');									//数量
		$("#cboOrdFreq").lookup("setValue",'');				//频次
		$("#cboOrdFreq").lookup("setText",'');	
		$("#cboOrdDurat").lookup("setValue",'');				//疗程
		$("#cboOrdDurat").lookup("setText",'');
		$("#cboOrdInstruc").lookup("setValue",'');			//用法
		$("#cboOrdInstruc").lookup("setText",'');
		$("#txtOrdDoseQty").val('');							//单次剂量
		$("#cboOrdUOMID").combobox("clear");				//单位
		$("#txtOrdNote").val('');								//医嘱备注
		$("#txtOrdPos").val('');							//检查部位
		$("#txtOrdPosShow").val('');
		$("#txtOrdLnkOrdDr").val(''); 						//关联医嘱
		$("#cboOrdFreq").lookup('setValue','');		//频次
		$("#cboOrdFreq").lookup('setText','');
		
		$("#cboOrdDurat").lookup('setValue','');		//疗程
		$("#cboOrdDurat").lookup('setText','');
		
		$("#cboOrdInstruc").lookup('setValue','');	//用法
		$("#cboOrdInstruc").lookup('setText','');	
	}
	
	//添加检查部位
	obj.IconAddChkPos = function(){
		var OrdMastID = $("#txtOrdMastID").lookup("getValue");
		if(OrdMastID==""||OrdMastID==undefined){
			$.messager.alert("提示","请先选择替换医嘱！");
			return;
		}
		
		var path="dhcapp.appreppartwin.csp?itmmastid="+OrdMastID+"&selOrdBodyPartStr=*";
		
		if($("#txtOrdPos").val()){
			var path="dhcapp.appreppartwin.csp?itmmastid="+OrdMastID+"&selOrdBodyPartStr=" + $("#txtOrdPos").val().split("||")[1]+"*"+$("#txtOrdPos").val().split("||")[2];
		}
		
		websys_showModal({
			url		:path,
			title	:'添加检查部位',
			iconCls	:'icon-w-import',  
			closable:true,
			width	:800,
			height	:500,
			originWindow:window,
			CallBackFunc:function(ret){
				if((ret!="")&&(ret!=undefined)){
					var arrPos=ret.split("^")
					var strPos=arrPos[0]+"||"+arrPos[1]+"||"+arrPos[2];
					$("#txtOrdPos").val(strPos);
					$("#txtOrdPosShow").val(arrPos[0]);
				}
			}
		})	
	}
}