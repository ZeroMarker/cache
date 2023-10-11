//页面Gui
function InitPatDtl(obj){
	InitFloatWin(obj);
	obj.IsReportDiag = '';
	obj.pindex ='';
	obj.rindex = '';
	obj.EpisodeID = '';
	obj.AdmDate = '';
	obj.DischDate = '';
	obj.DiagData = '';
	obj.ScreenData = '';
	obj.Bacterias ='';
	obj.DiagID = '';
	obj.ReportID = '';
	
	//加载病人信息
	obj.BuildPatIfo = function(pindex,rindex,objAdm,flg) {   //flg=1，科室汇总
		var htmlStr='';
		var htmlMsg='';
		var EpisodeID = objAdm.EpisodeID;
		var CategoryDR = objAdm.CategoryDR;
		var IMPOrdNo = objAdm.IMPOrdNo;
		obj.pindex = pindex;
		obj.rindex = rindex;
		if (!EpisodeID) return;
		// 1.病人基本信息
		htmlStr ='<div id=divPatInfo'+EpisodeID+' class="panel-heading">'
				+ '	<ul class="list-inline">'
				+ '		<li>'
				+ '			<span id="txtSuspendDesc' + EpisodeID + '" style="font-weight:bold;font-size:120%;">'+objAdm.SuspendDesc+'</span>'
				+ '			<span id="txtSuspendCode' + EpisodeID + '" style="display:none;">'+objAdm.SuspendCode+'</span></li>'
				+ '		</li>'
				+ '		<li class="middle-line">|</li>'
				+ '		<li>'+objAdm.PatName+' '+objAdm.RegNo+'</li>'
				+ '		<li class="middle-line">|</li>'
				+ '		<li>' + ((objAdm.CurrBed != '') ? objAdm.CurrBed : $g('空床')) + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.Sex + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.Age + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.VisitStatus +'</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.CurrLocDesc + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.InHospDate + $g('入院') + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + ((objAdm.AdmDocDesc != '') ? objAdm.AdmDocDesc : '') + $g('(医)')+'</li>'
				+ '	</ul>'
				+ '</div>'
				//border-left:1px solid #ccc;border-right:1px solid #ccc;border-bottom:1px solid #ccc;padding:0px 0px 10px 0px;
				//2. 感染诊断/疑似筛查信息
				+ '	<div class="table-nobottom" style="height:251px;border:1px solid #4C9CE4;padding:0px 0px 10px 0px;overflow-y: scroll;">'
				+ '	<div style="padding:5px;border-bottom:1px solid #ccc;">'
				+ ' 	<a id=btnConfirm'+EpisodeID+' onclick="btnConfirm_click(this,\'' + EpisodeID + '\',\'' + objAdm.RecordID + '\',\'' + objAdm.StatusDesc + '\',\'' +  CategoryDR + '\',\'' +IMPOrdNo + '\',\'' +objAdm.LocID + '\',\'' +  pindex+ '\',\'' +  rindex + '\')" > 确诊 </a>'		
				//+ '		<a id=btnRemove'+EpisodeID+' onclick="btnRemove_click(this,\'' + EpisodeID + '\',\'' +  objAdm.RecordID + '\',\'' +  objAdm.StatusDesc + '\',\'' +  CategoryDR + '\',\'' +IMPOrdNo + '\',\'' +objAdm.LocID + '\',\'' +  pindex+ '\',\'' +  rindex + '\')"> 排除 </a>'	
				+ '		<a id=btnAnalysis'+EpisodeID+' onclick="btnAnalysis_click(this,\'' + EpisodeID + '\',\'' +  objAdm.RecordID + '\',\'' +  objAdm.StatusDesc + '\',\'' +  CategoryDR + '\',\'' +IMPOrdNo + '\',\'' +objAdm.LocID + '\',\'' +  pindex+ '\',\'' +  rindex + '\')"> 排除 </a>'
				+ ' 	<a id=btnCheck'+EpisodeID+' onclick="btnCheck_click(this,\'' + EpisodeID + '\',\'' +  objAdm.RecordID + '\',\'' +  objAdm.StatusDesc + '\',\'' +  CategoryDR + '\',\'' +IMPOrdNo + '\',\'' +objAdm.LocID + '\',\'' +  pindex+ '\',\'' +  rindex + '\')" > 终结 </a>'	 		
				+ '		<a id=btnSummer'+EpisodeID+' onclick="btnOpen_click(this,\'' + EpisodeID + '\',\'' +  CategoryDR + '\',\'' +IMPOrdNo + '\',\'' + objAdm.LocID + '\')"> 调查表 </a>'
				+ '		<a id=btnMark'+EpisodeID+' onclick="btnMark_click(this,\'' + EpisodeID + '\',\'' + objAdm.LocID + '\',\'' +  pindex + '\',\'' +rindex + '\')"> 标记 </a>'
				+ '	</div>'
				+ ' <table id=gridScreenInfo'+objAdm.RecordID+'  data-options="border:false" ></table>'
				+ '	</div>'
				+ ' <div style="padding-bottom:10px;">'	
				
		if (flg<1 && CategoryDR!="") {    //科室汇总不显示消息
			htmlMsg= ' <div	style="margin-top:10px;height:450px;border:1px solid #ccc;overflow:auto;">'
				//3.消息记录
			    + ' <div id=divMessage'+objAdm.RecordID+' style="padding:10px;height:260px;overflow:auto">'	
				+ ' </div>'
				
				//4.发消息
				+ ' <div id=divSendMess'+objAdm.RecordID+' style="display: block; border-top: 1px solid #ccc;padding:10px 10px 10px 10px;">'		
				+ '		<textarea class="textbox"  id=txtMessage'+objAdm.RecordID+' style="width:99%;height:80px;border:none;outline: none;background-color:#fff;" placeholder="'+$g("请输入...")+'"></textarea> '
				+ ' 	<div style="padding-top:10px;text-align:right">'
				+ '			<a id=btnRead'+objAdm.RecordID+' onclick="btnRead_click(\'' + EpisodeID  + '\',\'' +  pindex+ '\',\'' +  rindex + '\',\'' + objAdm.RecordID + '\',\'' +IMPOrdNo + '\',\''+CategoryDR+ '\')"  style="margin-right:10px;">阅读</a>'
				+ '			<a id=btnSend'+objAdm.RecordID+' onclick="btnSend_click(\'' + EpisodeID  + '\',\'' +  pindex+ '\',\'' +  rindex + '\',\'' + objAdm.RecordID + '\',\'' +IMPOrdNo + '\',\''+CategoryDR+ '\')" >发送</a>'
				+ '			<span style="margin-left:-7px;font-size:12px;color: #fff;">|</span>'
				+ '			<a id=btnMSend'+objAdm.RecordID+' onclick="btnMSend_click(\'' + EpisodeID  + '\',\'' +  pindex+ '\',\'' +  rindex + '\',\'' + objAdm.RecordID + '\',\'' +IMPOrdNo + '\',\''+CategoryDR+ '\')" style="margin-left:-5px;background-color:#40A2DE;color: #fff;"></a>'	
				+ ' 	</div>'
				+ ' </div>'	
				+ ' </div>'	
			htmlStr += htmlMsg;
		}
				
		$('#divMain').empty().append(htmlStr);
		obj.IMPCategory ="";
		if(CategoryDR != ""){
			obj.IMPCategory = $m({
				ClassName:"DHCMA.IMP.BT.IMPCategory",
				MethodName:"GetObjById",
				aId:objAdm.CategoryDR
			}, false);
			if(obj.IMPCategory!=""){
				obj.IMPCategory=JSON.parse(obj.IMPCategory);
			}
		}
		
		if (flg<1) {
			obj.MsgLoad(EpisodeID,CategoryDR,IMPOrdNo,objAdm.RecordID);
		}
		
		//终结
		if (CategoryDR != ""&"1" == obj.IMPCategory.BTIsEnd) {
			$('#btnCheck'+EpisodeID).linkbutton({
				iconCls: 'icon-no',
				plain: true
			});
			
		}else {
			$('#btnCheck'+EpisodeID).hide();
		}
		//标记
		if (LocFlag==1) {
			$('#btnMark'+EpisodeID).linkbutton({
				iconCls: 'icon-stamp',
				plain: true
			});
			
		}else {
			$('#btnMark'+EpisodeID).hide();
		}
	
		//确诊
		if (CategoryDR == ""){
			$('#btnConfirm'+EpisodeID).hide();
		}else{
			$('#btnConfirm'+EpisodeID).linkbutton({
				iconCls: 'icon-ok',
				plain: true
			});
		}
		
		
		//排除、特因分析
		if (CategoryDR == ""){
			$('#btnAnalysis'+EpisodeID).hide();
		}else{
			$('#btnAnalysis'+EpisodeID).linkbutton({
				iconCls: 'icon-cancel',
				plain: true
			});
		}
		
		//操作
		if (CategoryDR != ""&"1" == obj.IMPCategory.BTIsOper){
			$('#btnSummer'+EpisodeID).linkbutton({
				iconCls: 'icon-edit',
				plain: true
			});
		}else{
			$('#btnSummer'+EpisodeID).hide();
		}
		
		
		obj.gridScreenInfo(EpisodeID,pindex,rindex,objAdm.RecordID);
		obj.gridScreenInfoLoad(EpisodeID,CategoryDR,IMPOrdNo,objAdm.RecordID);
		
		var cbox = $HUI.combobox("#cboReason", {
            url: $URL,
            editable: true,
            allowNull: true,
            defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
            valueField: 'xChildID',
            textField: 'BTDesc',
            onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
                param.ClassName = 'DHCMA.IMP.BTS.IMPCateReasonSrv';
                param.QueryName = 'QryIMPCateReason';
                param.aParRef = CategoryDR;
                param.ResultSetType = 'array';
            }
        });
        
        /*var cboCategory = $HUI.combobox("#cboCategory", {
            url: $URL,
            editable: true,
            allowNull: true,
            defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
            valueField: 'BTID',
            textField: 'CateDesc',
            onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
                param.ClassName = 'DHCMA.IMP.BTS.IMPCategorySrv';
                param.QueryName = 'QryIMPCategory';
                param.ResultSetType = 'array';
            }
        });*/
	}
	
	//加载患者消息
	obj.MsgLoad = function(EpisodeID,CategoryDR,IMPOrdNo,RecordId){
		$('#btnRead'+RecordId).linkbutton();
		$('#btnSend'+RecordId).linkbutton();	
		$('#btnMSend'+RecordId).linkbutton({
			iconCls:'icon-w-arrow-down',
			plain: true
		});	
		var Msghtml="";
		obj.Msg = $cm({
			ClassName:'DHCMA.IMP.IPS.IMPMessageSrv',
			QueryName:'QryMsgByPaadm',
			aPaadm:EpisodeID,
			aIMPCateDr:CategoryDR,
			aIMPOrdNo:IMPOrdNo
		},false);
		if (obj.Msg.total>0) {
			$('#divMessage'+RecordId).empty();
		
			for (var i=0;i<obj.Msg.total;i++){
				var rd = obj.Msg.rows[i];	
				if ((rd.CSMsgType==1)||(rd.CSMsgType==3)) {
					Msghtml += ' <div id="patMsgType1" class="right_message">'
							+ ' 	<div class="MessTitle">'
							+ '     	<span>'+rd.MTitle+'</span>'
							+ '     </div>'
							+ '     <div class="MessDtl">'	
							+ '			<div>'+ ((rd.CSIsRead==0) ? '<div style="background-color:red;color:#fff;border-radius:10px;font-size:10px;padding:3px;width:25px;font-weight: 600;">'+$g("未读")+'</div>' :'')+'</div>'
							+ ' 		<div class="message">'
							+ '     	    <div class="left message-green">'
							+ '					<div class="message-arrow"></div>'				
							+ '     			<div class="message-inner">'+rd.CSMessage+'</div>'
							+ '     		</div>'
							+ '     	</div>'	
							+ ' 		<div style="display: inline-block;">'
							+ ' 		     <div class="icon-doctor-green-pen" style="margin-top: 3px;width:25px;height:25px;border: 3px solid #16BBA2;border-radius: 15px;"></div>'
							+ '         </div>'
							+ '     </div>'
							+ ' </div>'				
				}else {
					Msghtml += ' <div id="patMsgType2" class="left_message">'
							+ ' 	<div class="MessTitle">'
							+ '     	<span>'+rd.MTitle+'</span>'
							+ '     </div>'
							+ '     <div class="MessDtl">'
							+ ' 		<div style="display: inline-block;">'
							+ ' 			<div class="icon-person" style="margin-top: 3px;width:25px;height:25px;border: 3px solid #509DE1;border-radius: 15px;"></div>'									
							+ '         </div>'
							+ ' 		<div class="message">'
							+ '     	    <div class="right message-blue">'
							+ '					<div class="message-arrow"></div>'				
							+ '     			<div class="message-inner">'+rd.CSMessage+'</div>'
							+ '     		</div>'
							+ '     	</div>'	
							+ ' 		<div>'+ ((rd.CSIsRead==0) ? '<div style="background-color:red;color:#fff;border-radius:10px;font-size:10px;padding:3px;width:25px;font-weight: 600;">'+$g("未读")+'</div>' :'')+'</div>'
							+ '     </div>'
							+ ' </div>'
				}
			}
		
			$('#divMessage'+RecordId).append(Msghtml);	
			return true;
		}			
	}
	
	//疑似筛查明细
	obj.gridScreenInfo = function(EpisodeID,pindex,rindex,RecordID) {
		$HUI.datagrid("#gridScreenInfo"+RecordID,{
			singleSelect: true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			fitColumns: true,   //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
			nowrap: false,      //设置为 true，则把数据显示在一行里。false 超长折行显示。
			columns:[[
				{field:'ScreenProgram',title:'筛查项目',width:150},	 				
				{field:'ScreenDetails',title:'筛查明细',width:370,
					formatter: function(value,row,index){
						 if(value.indexOf("!")>-1){
							var color='black';
							/**
							if (row.OprStatus=='0') {     //疑似、确诊后n之后有新疑似、排除后n之后有新疑似
								color= 'red;'; // return inline style
							}
							if ((row.ItmScreenID=='')&&(row.OprStatus=='2')){    //删除的感染报告
								color= 'gray;'; // return inline style
							}
							if (row.Status=='2') {   //排除后无新疑似
								color= 'gray;'; // return inline style
							}
							**/
							var DetailsList="";
							var text="";
							if(value.indexOf(";")>-1){
								var arr = new Array();
								arr=value.split(";");
								for(var i=0;i<arr.length;i++){
									var start = arr[i].indexOf("!");
									var stop = arr[i].length;
									DetailsList+=arr[i].substring(0,start)+";";
									text+=arr[i].substring(start+1,stop)+'<br/>';
								}
								var len=DetailsList.length;
								DetailsList=DetailsList.substring(0,len-1)
							}else{
								var start = value.indexOf("!");
								var stop = value.length;
								DetailsList=value.substring(0,start);
								text=value.substring(start+1,stop)+'<br/>';
							}
							
							
							return "<a href='#' id='ResultNote"+EpisodeID+"ind"+index+"' style='color:"+color+"' onmouseover='ShowDtlTip(\""+EpisodeID+"\",\""+index+"\",\""+DetailsList+"\");' >"+text +"</a>";
                        }else{
                            return value;
                        }
					}
				}
			]],
			rowStyler: function(index,row){
				
			},
			onLoadSuccess:function(data){ 
				
			}
			
		});
	}
	
	//加载疑似筛查明细
    obj.gridScreenInfoLoad = function(EpisodeID,CategoryDR,IMPOrdNo,RecordID){	
		$cm ({
			ClassName:'DHCMA.IMP.IPS.IMPRecordSrv',
			QueryName:'QryRecordResult',
			aEpisodeID:EpisodeID,
			CategoryDR:CategoryDR,
			aIMPOrdNo:IMPOrdNo
		},function(rs){
			$('#gridScreenInfo'+RecordID).datagrid('loadData', rs);				
		});
    }
    
    //加载临床科室患者明细
	obj.gridAdmInfoLoad2 = function(LocID){
		var PatInfo = $('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val();
		$cm ({
			ClassName:'DHCMA.IMP.IPS.IMPRecordSrv',
			QueryName:'QryRecordPatList',
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aLocID:LocID,	
			aPatInfo:PatInfo,
			aLocFlag:LocFlag,
			page:1,      //可选项，页码，默认1			
			rows:10    //可选项，获取多少条数据，默认50
		},function(rs){
			console.log()
			$('#gridAdmInfo').datagrid('loadData', rs);				
		});
    }
	
	//确诊 
	btnConfirm_click = function (el,EpisodeID,RecordID,StatusDesc,CategoryDR,IMPOrdNo,LocID,pindex,rindex) {
		var arrData = new Array();
		var arr = new Array();
		if (LocFlag==1){
			var rData = $('#gridAdmInfo').datagrid('getSelected');
		}else{
			var rData = $('#gridAdmInfo'+pindex).datagrid('getRows')[rindex];
		}
		arrData[arrData.length] =rData;
		var Status=rData.StatusDesc
		var CateFlag= rData.CateFlag;
		/**
		if(CateFlag.indexOf("_N")>= 0){
			arr=CateFlag.split("_N");
			CateFlag=arr[0]+arr[1];
		}
		**/
		if((Status == "确诊") || (Status == "终结")){
			$.messager.alert("提示", "该患者已" +Status+"，不允许操作!",'info');
			return;
		}
		
		obj.ProcessCaseXStatus(EpisodeID,RecordID,StatusDesc,CategoryDR,"确诊",1,"",IMPOrdNo,LocID,pindex,rindex,CateFlag);
	}
	
	//排除
	btnRemove_click = function (el,EpisodeID,RecordID,StatusDesc,CategoryDR,IMPOrdNo,LocID,pindex,rindex) { 
		if((StatusDesc != "自动标记") && (StatusDesc != "手动标记")){
			$.messager.alert("提示", "该患者已" +StatusDesc+"，不允许操作!",'info');
			return;
		}
        $.messager.prompt("提示", "请输入排除原因：", function (r){
	        if (r) {
	        	obj.ProcessCaseXStatus(EpisodeID,RecordID,StatusDesc,CategoryDR,"排除",0,r,IMPOrdNo,LocID,pindex,rindex);
	        }else if(r===""){
		        $.messager.alert("提示", "原因为空，请输入排除原因!",'info',function(r){
			        btnRemove_click();
		        });
	        }
        });
	}
	
	//标记、排除、审核
	obj.ProcessCaseXStatus=function(EpisodeID,RecordID,StatusDesc,CategoryDR,SDesc,aStatus,aOpinion,IMPOrdNo,LocID,pindex,rindex,CateFlag){
		var InputStr="";
		for (var rowIndex = 0; rowIndex < 1; rowIndex++){		
			var InputStr1=RecordID
			InputStr1=InputStr1 + "^" + aStatus;
			InputStr1=InputStr1 + "^" + aOpinion;
			InputStr1=InputStr1 + "^" + session["LOGON.CTLOCID"];
			InputStr1=InputStr1 + "^" + session["LOGON.USERID"];
			InputStr=InputStr + "!" + InputStr1	
		}
		$m({
			ClassName:"DHCMA.IMP.IPS.IMPRecordSrv",
			MethodName:"UpdateStatus",
			aInputStr:InputStr,
			aSeparete:"^"
		},function(ret){
			var success= ret.split("/")[0];
			var fail= ret.split("/")[1];
			
			if (success > 0){
				//增加确诊日志保存
				if (aStatus == 1){
				var LogInputStr = RecordID;
					LogInputStr = LogInputStr + "^" + "";
					LogInputStr = LogInputStr + "^" + "";
					LogInputStr = LogInputStr + "^" + "";
					LogInputStr = LogInputStr + "^" + aStatus;
					LogInputStr = LogInputStr + "^" + "";
					LogInputStr = LogInputStr + "^" + "";
					LogInputStr = LogInputStr + "^" + "";
					LogInputStr = LogInputStr+session['LOGON.USERID'];
				var retLog =$m({
					ClassName:"DHCMA.IMP.IP.IMPRecordLog",
					MethodName:"Update",
					aInputStr:LogInputStr
				}, false);
				}
				
				if (pindex) { //存在左侧列表
					if (LocFlag==1) { //刷新科室明细列表
						//obj.gridAdmInfoLoad2(LocID);
						
						$('#gridAdmInfo').datagrid('updateRow', {
							index: pindex,
							row: {
								'StatusDesc':SDesc,
								'CateFlag':CateFlag
								}
							});
							
							var currPage=1;
							var options = $('#gridAdmInfo').datagrid("getPager").data("pagination").options;
							currPage = options.pageNumber;	
							obj.SelectAdmRow2(EpisodeID,currPage,LocID,RecordID);  //刷新明细表格
					}else {  //刷新明细表格
						var currPage=1;
						if (rindex>=0) {
							var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
							currPage = options.pageNumber; 
						}
						obj.SelectAdmRow(EpisodeID,pindex,currPage,RecordID);  //刷新明细表格
					}
				}
				$.messager.popover({msg: SDesc+'成功！',type:'success',timeout: 1000});
				obj.gridScreenInfoLoad(EpisodeID,CategoryDR,IMPOrdNo,RecordID); //刷新
				//obj.gridLocInfLoad();
				//obj.gridAdmInfoLoad2(LocID);
			}else{
				$.messager.popover({msg: SDesc+'失败！',type:'success',timeout: 1000});
			}
			
		});
	}
	
	//特因分析
	btnAnalysis_click = function (el,EpisodeID,RecordID,StatusDesc,CategoryDR,IMPOrdNo,LocID,pindex,rindex) {
		if((EpisodeID == "") ){
			$.messager.alert("提示", "请先选择患者，不允许操作!",'info');
			return;
		}
		var arrData = new Array();
		var arr = new Array();
		if (LocFlag==1){
			var rData = $('#gridAdmInfo').datagrid('getSelected');
		}else{
			var rData = $('#gridAdmInfo'+pindex).datagrid('getRows')[rindex];
		}
		arrData[arrData.length] =rData;
		var Status=rData.StatusDesc;
		var CateFlag= rData.CateFlag;
		debugger;
		/**
		if(CateFlag.indexOf("_N")< 0){
			arr=CateFlag.split(".");
			CateFlag=arr[0]+"_N."+arr[1];
		}
		**/
		if((Status == "排除") || (Status == "终结")){
			$.messager.alert("提示", "该患者已" +Status+"，不允许操作!",'info');
			return;
		}
		
		$('#txtAtt').val('');
		$('#winIMPReason').show();
		obj.winIMPReason = $HUI.dialog('#winIMPReason',{
			title:'排除原因',
			iconCls:'icon-w-edit',
			resizable:true,
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'保存',
				handler:function(){
				//保存
				var retval = obj.Reason_Save(EpisodeID,RecordID);
				if(parseInt(retval)<0){
					return;
				}else{
				//增加排除日志保存
					var LogInputStr = RecordID;
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr + "^" + 2;
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr+session['LOGON.USERID'];
					var retLog =$m({
						ClassName:"DHCMA.IMP.IP.IMPRecordLog",
						MethodName:"Update",
						aInputStr:LogInputStr
					}, false);
				
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					obj.gridScreenInfoLoad(EpisodeID,CategoryDR,IMPOrdNo,RecordID); //刷新
					$HUI.dialog('#winIMPReason').close();
					if (pindex) { //存在左侧列表
						if (LocFlag==1) { //刷新科室明细列表
							//obj.gridAdmInfoLoad2(LocID);
							
							$('#gridAdmInfo').datagrid('updateRow', {
							index: pindex,
							row: {
								'StatusDesc':"排除",
								'CateFlag':CateFlag
								}
							});
							var currPage=1;
							var options = $('#gridAdmInfo').datagrid("getPager").data("pagination").options;
							currPage = options.pageNumber;	
							obj.SelectAdmRow2(EpisodeID,currPage,LocID,RecordID);  //刷新明细表格
						}else {  //刷新科室汇总列表

							var currPage=1;
							if (rindex>=0) {
								var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
								currPage = options.pageNumber;	
							}
							obj.SelectAdmRow(EpisodeID,pindex,currPage,RecordID);  //刷新明细表格
						}
					}
				}
				}
			},{
					text:'关闭',
					handler:function(){
						$HUI.dialog('#winIMPReason').close();
					}
				}]
			});
		}
	
	//保存特因
	obj.Reason_Save = function(EpisodeID,RecordID){
		if (EpisodeID == '') {
			$.messager.alert("提示", "排除患者不允许为空！", "info");
			return -1;
		}	
		var errinfo = "";
		var Reason = $('#cboReason').combobox('getValue');
		var Reasontxt = $('#txtAtt').val();
		
		if ((!Reason)&&(!Reasontxt)) {
			errinfo = errinfo + $g('特因分类、排除原因不能同时为空！')+"<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return -1;
		}
		var inputStr=RecordID
		inputStr = inputStr + CHR_1 + Reason;
		inputStr = inputStr + CHR_1 + Reasontxt;
		
		var flg = $m({
			ClassName:"DHCMA.IMP.IPS.IMPRecordSrv",
			MethodName:"UpdateReason",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		
		return flg;
	}
	
	
	/**审核
	btnCheck_click = function (el,EpisodeID,RecordID,StatusDesc,CategoryDR,IMPOrdNo,LocID,pindex,rindex) {
		var arrData = new Array();
		if (LocFlag==1){
			var rData = $('#gridAdmInfo').datagrid('getSelected');
		}else{
			var rData = $('#gridAdmInfo'+pindex).datagrid('getRows')[rindex];
		}
		arrData[arrData.length] =rData;
		var Status=rData.StatusDesc
		if(Status != "确诊"){
			$.messager.alert("提示", "该患者已"+Status+" ，不允许操作!",'info');
			return;
		}
		$.messager.prompt("提示", "请输入审核意见：", function (r){
	        if (r) {
	        	obj.ProcessCaseXStatus(EpisodeID,RecordID,StatusDesc,CategoryDR,"审核",2,r,IMPOrdNo,LocID,pindex,rindex);
	        }else if(r===""){
		        $.messager.alert("提示", "原因为空，请输入审核意见!",'info',function(r){
			        btnCheck_click();
		        });
	        }
        });
	}
	**/
	//手动标记
	/**
	btnMark_click = function (el,EpisodeID,LocID,pindex,rindex){
		if((EpisodeID == "") ){
			$.messager.alert("提示", "请先选择患者，不允许操作!",'info');
			return;
		}
		$('#winIMPCategory').show();
		obj.winIMPCategory = $HUI.dialog('#winIMPCategory',{
			title:'标记分类',
			iconCls:'icon-w-edit',
			resizable:true,
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'保存',
				handler:function(){
				//保存
				var retval = obj.Category_Save(EpisodeID);
				if(retval.indexOf("^") < 0){
					$.messager.alert("提示","保存失败！","info");
				}else{
					var arr=new Array();
					arr=retval.split('^');
					var CategoryDR = arr[0];
					var IMPOrdNo = arr[1];
					var CateFlag = arr[2];
					var HappenDate = arr[3];
					var RecordID = arr[4];
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					//obj.gridScreenInfoLoad(EpisodeID,CategoryDR,IMPOrdNo); //刷新
					$HUI.dialog('#winIMPCategory').close();
					if (pindex) { //存在左侧列表
						
						$('#gridAdmInfo').datagrid('updateRow', {
							index: pindex,
							row: {
								'HappenDate':HappenDate,
								'CateFlag':CateFlag,
								'CategoryDR':CategoryDR,
								'StatusDesc':"手动标记",
								'RecordID':RecordID,
								'IMPOrdNo':IMPOrdNo
								}
							});
						
							var currPage=1;
							var options = $('#gridAdmInfo').datagrid("getPager").data("pagination").options;
							currPage = options.pageNumber;	
							obj.SelectAdmRow2(EpisodeID,currPage,LocID,RecordID);  //刷新明细表格
							
					}
				}
				}
			},{
				text:'关闭',
					handler:function(){
						$HUI.dialog('#winIMPCategory').close();
					}
			}]
		});
	}
	
	//保存分类
	obj.Category_Save = function(EpisodeID){
		if (EpisodeID == '') {
			$.messager.alert("提示", "标记患者不允许为空！", "info");
			return -1;
		}	
		var errinfo = "";
		var Category = $('#cboCategory').combobox('getValue');
		
		if (!Category) {
			errinfo = errinfo + "重点患者分类不能为空！<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr=""
		inputStr = inputStr + CHR_1 + EpisodeID;
		inputStr = inputStr + CHR_1 + Category;
		
		var flg = $m({
			ClassName:"DHCMA.IMP.IPS.IMPRecordSrv",
			MethodName:"UpdateMark",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		
		return flg;
	}
	**/
	$('#winQCEntity').dialog({
		title: '标记分类',
		closable: true,
		closed:true,
		modal: true
	});
	
	
	btnMark_click = function (el,EpisodeID,LocID,pindex,rindex){
		
		$cm({
			ClassName:"DHCMA.IMP.BTS.IMPCategorySrv",
			QueryName:"QryIMPCategory"	
			},function(data){
				var dicList=data.rows
				var len=dicList.length,columns=4,listHtml="<div>"
				var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
				var count = parseInt(len/columns)+1;
				for (var index =0; index< count; index++) {
					var listlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
					listHtml +="<div style='padding:20px'>"; 
					for (var dicIndex = index*columns; dicIndex < listlen; dicIndex++) {
						if("是"==dicList[dicIndex].BTIsManMark){
							var dicSubList = dicList[dicIndex];
							listHtml += " <div style='padding:0px;text-align:center;float:left;width:"+per+"'><a style='cursor:pointer' onClick='btnMark_save("+EpisodeID+",\""+LocID+"\",\""+pindex+"\",\""+ dicSubList.BTID+"\")' id="+dicSubList.BTID+">"+"<img src='../scripts/DHCMA/img/spe/"+dicSubList.CateFlag+"'/><p>"+" "+dicSubList.CateDesc+"</p></a></div>";  
						}
					} 
					listHtml +="</div>"
					listHtml +="<div style='clear:both'></div>"
				}
				listHtml +="</div>"
				$('#QCEntityList').html(listHtml); 
				$.parser.parse('#QCEntityList');  //解析checkbox
			})
		
		$HUI.dialog('#winQCEntity').open();	
	}
	
	btnMark_save=function(EpisodeID,LocID,pindex,Category){
			if (EpisodeID == '') {
				$.messager.alert("提示", "标记患者不允许为空！", "info");
				return -1;
			}	
			var errinfo = "";
			if (!Category) {
				errinfo = errinfo + "重点患者分类不能为空！<br>";
			}	
			if (errinfo) {
				$.messager.alert("错误提示", errinfo, 'info');
				return;
			}
			var inputStr=""
			inputStr = inputStr + CHR_1 + EpisodeID;
			inputStr = inputStr + CHR_1 + Category;
			
			var flg = $m({
				ClassName:"DHCMA.IMP.IPS.IMPRecordSrv",
				MethodName:"UpdateMark",
				aInputStr:inputStr,
				aSeparete:CHR_1
			},false);
			
			if(flg==-1){
				$.messager.alert("提示","该重点患者类型不允许手动标记！","info");
			}else if(flg==-2){
				$.messager.alert("提示","该重点患者类型不允许重复标记！","info");
			}else if(flg==-102){
				$.messager.alert("提示","该患者不存在手术不允许标记为非计划重返手术！","info");
			}else if(flg==-103){
				$.messager.alert("提示","该患者不存在手术不允许标记为手术并发症！","info");
			}else if(flg.indexOf("^") < 0){
				$.messager.alert("提示","保存失败！","info");
			}else{
				var arr=new Array();
				arr=flg.split('^');
				var CategoryDR = arr[0];
				var IMPOrdNo = arr[1];
				var CateFlag = arr[2];
				var HappenDate = arr[3];
				var RecordID = arr[4];
				
				//增加手动标记日志保存
					var LogInputStr = RecordID;
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr + "^" + 4;
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr + "^" + "";
						LogInputStr = LogInputStr+session['LOGON.USERID'];
					var retLog =$m({
						ClassName:"DHCMA.IMP.IP.IMPRecordLog",
						MethodName:"Update",
						aInputStr:LogInputStr
					}, false);
				
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				$HUI.dialog('#winQCEntity').close();
				if (pindex) { //存在左侧列表
					$('#gridAdmInfo').datagrid('updateRow',{
						index: pindex,
						row: {
							'HappenDate':HappenDate,
							'CateFlag':CateFlag,
							'CategoryDR':CategoryDR,
							'StatusDesc':"手动标记",
							'RecordID':RecordID,
							'IMPOrdNo':IMPOrdNo
						}
					});
					var currPage=1;
					var options = $('#gridAdmInfo').datagrid("getPager").data("pagination").options;
					currPage = options.pageNumber;	
					obj.SelectAdmRow2(EpisodeID,currPage,LocID,RecordID);  //刷新明细表格
				}
			}
			
			
		
		}
	
	//终结
	btnCheck_click = function (el,EpisodeID,RecordID,StatusDesc,CategoryDR,IMPOrdNo,LocID,pindex,rindex) {
		var arrData = new Array();
		var arr = new Array();
		if (LocFlag==1){
			var rData = $('#gridAdmInfo').datagrid('getSelected');
		}else{
			var rData = $('#gridAdmInfo'+pindex).datagrid('getRows')[rindex];
		}
		arrData[arrData.length] =rData;
		var Status=rData.StatusDesc
		var CateFlag= rData.CateFlag;
		/**
		if(CateFlag.indexOf("_N")>= 0){
			arr=CateFlag.split("_N");
			CateFlag=arr[0]+arr[1];
		}
		**/
		if((Status == "终结")){
			$.messager.alert("提示", "该患者已" +Status+"，不允许操作!",'info');
			return;
		}
		obj.ProcessCaseXStatus(EpisodeID,RecordID,StatusDesc,CategoryDR,"终结",3,"",IMPOrdNo,LocID,pindex,rindex,CateFlag);
	}
	
	//打开登记表
	btnOpen_click = function (el,EpisodeID,CategoryDR,IMPOrdNo,RecordID) {
		
		var IMPCateRet =$m({
			ClassName:"DHCMA.IMP.BT.IMPCategory",
			MethodName:"GetObjById",
			aId:CategoryDR
		}, false);
		if(IMPCateRet){
			var IMPCateRetJson=JSON.parse(IMPCateRet);
			IMPCateDesc=IMPCateRetJson.BTDesc;
		}
		
		
		if (IMPCateDesc=="手术并发症"){
			var strUrl= "./dhcma.imp.ip.opercompreg.csp?1=1&EpisodeID=" + EpisodeID+"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:$g('手术并发症登记'),
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.gridScreenInfoLoad(EpisodeID,CategoryDR,IMPOrdNo,RecordID); //刷新
				} 
			});
		}else if(IMPCateDesc=="非计划重返手术"){
			var strUrl= "./dhcma.imp.ip.urtoperreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:$g('非计划重返手术登记'),
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.gridScreenInfoLoad(EpisodeID,CategoryDR,IMPOrdNo,RecordID); //刷新
				} 
			});
		}else if(IMPCateDesc=="危重病例"){
			var strUrl= "./dhcma.imp.ip.criticalillreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:$g('危重病例报告'),
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.gridScreenInfoLoad(EpisodeID,CategoryDR,IMPOrdNo,RecordID); //刷新
				} 
			});
		}else if (IMPCateDesc=="非计划重返住院"){
			var strUrl= "./dhcma.imp.ip.urthospreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:$g('非计划重返住院登记'),
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.gridScreenInfoLoad(EpisodeID,CategoryDR,IMPOrdNo,RecordID); //刷新
				} 
			});
		}else if(IMPCateDesc=="长期住院"){
			var strUrl= "./dhcma.imp.ip.langhospreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:$g('长期住院报告'),
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.gridScreenInfoLoad(EpisodeID,CategoryDR,IMPOrdNo,RecordID); //刷新
				} 
			});
		}else{
			$.messager.alert("提示", "该分类还没有登记表,不允许操作!",'info');
			return;
		}
		
	}
	
    // ****************************** ↓↓↓ 刷新数据
   	//刷新左侧数据
    obj.RefreshTable = function(EpisodeID,pindex,rindex,aSuspendCode) {	
		if (LocFlag==1) {    //刷新科室明细列表	
			var ConfRepCnt  = $m({
				ClassName:"DHCHAI.IRS.CCScreeningSrv",
				MethodName:"GetConfRepCnt",
				aEpisodeID:EpisodeID
			},false);
			var CntArr = ConfRepCnt.split("^");
			var NeedRepCnt = CntArr[0]-CntArr[1];
			if (NeedRepCnt<0) NeedRepCnt=0;
			var Accordion = $('#divAccordion').accordion('getSelected');
			if (Accordion){
				var index = $('#divAccordion').accordion('getPanelIndex', Accordion);
				if (index==1) {
					$('#gridDutyList').datagrid('updateRow', {
						index: pindex,
						row: {
							'SuspendCode':aSuspendCode,
							'NeedRepCnt':NeedRepCnt
						}
					});
				}else {
					$('#gridAdmInfo').datagrid('updateRow', {
						index: pindex,
						row: {
							'SuspendCode':aSuspendCode,
							'NeedRepCnt':NeedRepCnt
						}
					});
				}
			}
		}else {   //刷新科室汇总、科室明细列表	
		    if ( $('#gridLocInf').length <= 0 ){   //确诊未报等界面没有左侧科室列表不刷新
		        if ($('#gridPatList').length>0) {
			        gridPatListLoad();
		        }
		   	 	return;
		    }		    
			var currPage=1;
			var expander = $('#gridLocInf').datagrid('getExpander',pindex);  //获取展开行
			if(expander.length && expander.hasClass('datagrid-row-collapse')){  //未展开行获取不到页码信息，无需刷新明细
				if (rindex>=0) {
					var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
					currPage = options.pageNumber; 
				}
			}
			
			var rows = $('#gridLocInf').datagrid('getSelected',pindex);
			var LocID = rows.LocID;		
			var PatInfo = $('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val();
			var LocInfo = $cm({
				ClassName:"DHCHAI.IRS.CCScreeningSrv",
				QueryName:"QrySuRuleLocList",
				aTypeFlag:'1',
				aDateFrom:$('#aDateFrom').datebox('getValue'), 
				aDateTo:$('#aDateTo').datebox('getValue'), 
				aHospIDs:$('#cboHospital').combobox('getValue'), 
				aViewFlag:2,	
				aGroupUser:"",
				aPatInfo:PatInfo,
				aLocID:LocID
			},false);
			
			var ScreenProCnt = LocInfo.rows[0].ScreenProCnt;
			var ConfirmCnt = LocInfo.rows[0].ConfirmCnt;
			var DiagNoRepCnt = LocInfo.rows[0].DiagNoRepCnt;		
		   
			$('#gridLocInf').datagrid('updateRow', {
				index: pindex,
				row: {
					'ScreenProCnt':ScreenProCnt,
					'ScreenLogCnt':DiagNoRepCnt+" / "+ConfirmCnt
				}
			});
			
			if(expander.length && expander.hasClass('datagrid-row-collapse')){
				$('#gridLocInf').datagrid('collapseRow',pindex); //折叠
				$('#gridLocInf').datagrid('expandRow',pindex);   //展开						
				obj.SelectAdmRow(EpisodeID,pindex,currPage);  //刷新明细表格						
			}
					
		}	
	}	
   
   //刷新并选中明细表格数据
   obj.SelectAdmRow = function(EpisodeID,pindex,currPage,RecordID){
	   var PatInfo = $('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val();
		$cm({
			ClassName:"DHCMA.IMP.IPS.IMPRecordSrv",
			QueryName:"QryRecordLocList",
			aHospIDs:$('#cboHospital').combobox('getValue'), 
			aCategory:$('#cboCategory').combobox('getValue'), 
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aPatInfo:PatInfo,			
			page:1,      //可选项，页码，默认1
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridLocInf').datagrid('loadData', rs);
			$('#gridLocInf').datagrid('collapseRow',pindex); //折叠
	   		$('#gridLocInf').datagrid('expandRow',pindex);   //展开
	   		$('#gridAdmInfo'+pindex).datagrid({
				pageNumber:currPage,
				/*			
				onBeforeLoad: function (param) {  //加载两遍才能正确定位翻页
		            var firstLoad = $(this).attr("firstLoad");
		            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
		            {
		                $(this).attr("firstLoad","true");
		                return false;
		            }
		            return true;
				},
				*/
				onLoadSuccess:function(data) {
					//获取数据列表中的所有数据
					var rows = data.rows;
					var length = rows.length;
					//循环数据找出列表中ID和需要选中数据的ID相等的数据并选中
					for(var i=0;i<length;i++){
						var arowIdID = rows[i].RecordID;
						if(arowIdID==RecordID){
							var index = $('#gridAdmInfo'+pindex).datagrid("getRowIndex",rows[i]);
							$('#gridAdmInfo'+pindex).datagrid('scrollTo', index); //滚动到指定行
							$('#gridAdmInfo'+pindex).datagrid('selectRow', index); //选中指定行
							//$('#gridAdmInfo'+pindex).datagrid('highlightRow', index);
							var row = $('#gridAdmInfo'+pindex).datagrid('getSelected');
							obj.BuildPatIfo(pindex,index,row,0);
						}
					}
			        
					setTimeout(function () {
						$('#gridLocInf').datagrid('fixDetailRowHeight', pindex);
					}, 0);
				}
			});	
		});
	   
		
   }
   
   //刷新并选中临床明细表格数据
   obj.SelectAdmRow2 = function(EpisodeID,currPage,LocID,RecordID){
	   $('#gridAdmInfo').datagrid({
		   pageNumber:currPage,
		   onLoadSuccess:function(data) {
			 	$("#gridAdmInfo").datagrid('selectRecord',RecordID);
				  var row = $('#gridAdmInfo').datagrid('getSelected');
				  var rowIndex=$('#gridAdmInfo').datagrid('getRowIndex',$('#gridAdmInfo').datagrid('getSelected'));
				 
				  obj.BuildPatIfo(rowIndex,'',row,0);  //加载单个病人信息
			   }
		   })
	  //obj.gridAdmInfoLoad2(LocID)
	  //$("#gridAdmInfo").datagrid("reload"); 
	  
	 /**
	  var index = $('#gridAdmInfo').datagrid('getRowIndex', data.RecordID); 
	  $('#gridAdmInfo').datagrid('scrollTo', index);
	  $('#gridAdmInfo').datagrid('selectRow', index);
	  
	   var rows = $("#gridAdmInfo").datagrid("getRows"); 
	   var length = rows.length;
	   
	   //循环数据找出列表中ID和需要选中数据的ID相等的数据并选中
		for(var i=0;i<length;i++){
		 	var rowIdID = rows[i].RecordID;  
			if(rowIdID==RecordID){
				var index = $('#gridAdmInfo').datagrid("getRowIndex",rows[i]);
				$('#gridAdmInfo').datagrid('scrollTo', index); //滚动到指定行
				$('#gridAdmInfo').datagrid('selectRow', index); //选中指定行
			}
		}
		**/
   }
	
	
	//发送消息
	btnSend_click = function (EpisodeID,pindex,rindex,RecordId,IMPOrdNo,CategoryDR) {
		// 1院感、2临床
		var MsgType=1;
		if (LocFlag==1) MsgType=2;
		
		var MsgTxt= $('#txtMessage'+RecordId).val().replace(/\^/g,"").replace(/\r?\n/g,"<br />");
		if (MsgTxt == '') {
			$.messager.alert("提示", "消息内容不允许为空！", "info");
			return;
		}
		var retval = obj.Msg_Save("",EpisodeID,MsgType,MsgTxt,"0",RecordId);
		if (parseInt(retval)>0){
			//切换图片
			$('#Message'+RecordId).toggleClass("write-message",false);
			$('#Message'+RecordId).toggleClass("yellow-message",true);
			$('.yellow-message').attr("src",'../scripts/DHCMA/HAI/img/消息-选中.png');
			if (pindex) { //存在左侧列表
				if (LocFlag==1) { //刷新科室明细列表	
					$('#gridAdmInfo').datagrid('updateRow', {
						index: pindex,
						row: {'IsMessage':1}
					});
					var currPage=1;
					var options = $('#gridAdmInfo').datagrid("getPager").data("pagination").options;
					currPage = options.pageNumber;	
					obj.SelectAdmRow2(EpisodeID,currPage,"",RecordID);  //刷新明细表格
				}else {  //刷新科室汇总列表
					if ( $('#gridLocInf').length <= 0 ){   //确诊未报等界面没有左侧科室列表不刷新
				        if ($('#gridPatList').length>0) {
					        gridPatListLoad();
				        }
				   	 	return;
				    }
					var currPage=1;
					var expander = $('#gridLocInf').datagrid('getExpander',pindex);  //获取展开行
					if(expander.length && expander.hasClass('datagrid-row-collapse')){  //未展开行获取不到页码信息，无需刷新明细
						if (rindex>=0) {
							var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
							currPage = options.pageNumber; 
						}
					}	
					$('#gridLocInf').datagrid('updateRow', {  //更新一行
						index: pindex
					});				
					
					if(expander.length && expander.hasClass('datagrid-row-collapse')){
						$('#gridLocInf').datagrid('collapseRow',pindex); //折叠
						$('#gridLocInf').datagrid('expandRow',pindex);   //展开			
						
						obj.SelectAdmRow(EpisodeID,pindex,currPage,RecordId);  //刷新明细表格			
					}
				}	
			}
			//obj.MsgLoad(EpisodeID,CategoryDR,IMPOrdNo,RecordId); //刷新单个患者消息
			$('#txtMessage'+RecordId).val('');
			$.messager.popover({msg: '消息发送成功！',type:'success',timeout: 2000});
		} else {
			$.messager.alert("提示", "消息发送失败！", "info");
			return;
		}
	}
	
	//阅读消息
	btnRead_click = function (EpisodeID,pindex,rindex,RecordId,IMPOrdNo,CategoryDR) {
		// 1院感、2临床
		var MsgType=1;
		if (LocFlag==1) MsgType=2;
		
		var retval  = $m({
			ClassName:"DHCMA.IMP.IPS.IMPMessageSrv",
			MethodName:"ReadMessage",
			aEpisodeID:EpisodeID, 
			aIMPCateDr:CategoryDR,
			aIMPOrdNo:IMPOrdNo,
			aUserID:session['LOGON.USERID'], 
			aTypeCode:MsgType
		},false);
	
		if (parseInt(retval)>0){
			obj.MsgLoad(EpisodeID,CategoryDR,IMPOrdNo,RecordId); //刷新单个患者消息
			if (pindex) { //存在左侧列表
				if (LocFlag==1) { //刷新科室明细列表	
					$('#gridAdmInfo').datagrid('updateRow', {
						index: pindex,
						row: {'LocUnRead':0}
					});
				}else {  //刷新明细表格
					var currPage=1;
					if (rindex>=0) {
						var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
						currPage = options.pageNumber; 
					}
					obj.SelectAdmRow(EpisodeID,pindex,currPage,RecordId);  //刷新明细表格								
				}	
			}
			$.messager.popover({msg: '消息阅读成功！',type:'success',timeout: 2000});
		}else if(parseInt(retval)==0) {
			$.messager.popover({msg: '无未读消息需阅读！',type:'info',timeout: 2000});
		}else  {
			$.messager.popover({msg: '消息失败！',type:'error',timeout: 2000});
		}	
	}
	
	//发送消息更多
	btnMSend_click = function (EpisodeID,pindex,rindex,RecordId,IMPOrdNo,CategoryDR) {
		// 1院感、2临床
		var MsgType=1;
		if (LocFlag==1) MsgType=2;
		
		obj.MMsg = $cm({
			ClassName:'DHCMA.Util.BTS.DictionarySrv',
			QueryName:'QryDictByType',
			aTypeCode:"IMPMessageItem",
			aActive:1
		},false);
		
		var htmlMMsg='<div id=ulqMsg'+RecordId+' style="text-align:right;">';
		for (var j=0;j<obj.MMsg.total;j++){
			var rd = obj.MMsg.rows[j];	
			var message=rd["BTDesc"];
			htmlMMsg += '<li style="list-style:none;" text="'+message+'"><a onclick="btnMSend_click_a(\''+message+'\',\''+EpisodeID+'\',\''+MsgType+'\',\''+IMPOrdNo+'\',\''+RecordId+'\',\''+pindex+'\',\''+rindex+'\')" href="#" style="color:blue">'+message+'</a></li>';
		}
		htmlMMsg +='</div>';
		$('#btnMSend'+RecordId).popover({
			width:'300px',
			height:'200px',
			content:htmlMMsg,
			trigger:'hover',
			placement:'left',
			type:'html'
		});
		$('#btnMSend'+RecordId).popover('show');  	
	}
	//消息更多的点击事件
	btnMSend_click_a = function(MsgTxt,EpisodeID,MsgType,IMPOrdNo,RecordId,pindex,rindex){
			//var MsgTxt = $(this).attr("text");
			if (MsgTxt == '') {
				$.messager.alert("提示", "消息内容不允许为空！", "info");
				return;
			}
			var retval = obj.Msg_Save("",EpisodeID,MsgType,MsgTxt,"0",RecordId);
			if (parseInt(retval)>0){
				//切换图片
				$('#Message'+RecordId).toggleClass("write-message",false);
				$('#Message'+RecordId).toggleClass("yellow-message",true);
				$('.yellow-message').attr("src",'../scripts/DHCMA/HAI/img/消息-选中.png');
				
				if (pindex) { //存在左侧列表
					
					if (LocFlag==1) { //刷新科室明细列表	
						$('#gridAdmInfo').datagrid('updateRow', {
							index: pindex,
							row: {'IsMessage':1}
						});
						var currPage=1;
						var options = $('#gridAdmInfo').datagrid("getPager").data("pagination").options;
						currPage = options.pageNumber;	
						obj.SelectAdmRow2(EpisodeID,currPage,"",RecordID);  //刷新明细表格
					}else {  //刷新科室汇总列表
						if ( $('#gridLocInf').length <= 0 ){   //确诊未报等界面没有左侧科室列表不刷新
					        if ($('#gridPatList').length>0) {
						        gridPatListLoad();
					        }
					   	 	return;
					    }
						var currPage=1;
						var expander = $('#gridLocInf').datagrid('getExpander',pindex);  //获取展开行
						if(expander.length && expander.hasClass('datagrid-row-collapse')){  //未展开行获取不到页码信息，无需刷新明细
							if (rindex>=0) {
								var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
								currPage = options.pageNumber; 
							}
						}
						
						if(expander.length && expander.hasClass('datagrid-row-collapse')){
							$('#gridLocInf').datagrid('collapseRow',pindex); //折叠
							$('#gridLocInf').datagrid('expandRow',pindex);   //展开							
							obj.SelectAdmRow(EpisodeID,pindex,currPage,RecordId);  //刷新明细表格
						}
					}
				}
				$('#txtMessage'+RecordId).val('');
				//obj.MsgLoad(EpisodeID,CategoryDR,IMPOrdNo,RecordId); //刷新单个患者消息
				$.messager.popover({msg: '消息发送成功！',type:'success',timeout: 2000});
			} else {
				$.messager.alert("提示", "消息发送失败！", "info");
				return;
			}
	}
	
	//保存消息
	obj.Msg_Save=function(ID,EpisodeID,MsgType,MsgTxt,IsRead,RecordId){	
		var CSEpisodeDr = EpisodeID;
		var CSMsgType   = MsgType;  // 1院感、2临床
		var CSMsgDate   = "";
		var CSMsgTime   = "";  //时间
		var CSMsgUserDr = session['LOGON.USERID']; //$.LOGON.USERID;
		var CSMsgLocDr  = session['LOGON.CTLOCID']; //$.LOGON.LOCID;  
		var CSMessage   = MsgTxt;
		var CSIsRead    = IsRead;
		var CSReadDate  = "";
		var CSReadTime  = "";
		var ChildSub  = "";
		var CSReadUserDr = session['LOGON.USERID']; //$.LOGON.USERID;
		var MsgDtlID    = "";
		var HospID      = session['DHCMA.HOSPID'];
		if (CSMessage == '') {
			$.messager.alert("提示", "消息内容不允许为空！", "info");
			return -1;
		}
		
		var InputStr = RecordId;
		InputStr += "^" + ChildSub;
		InputStr += "^" + CSMsgType;
		InputStr += "^" + CSMsgDate;
		InputStr += "^" + CSMsgTime;
		InputStr += "^" + CSMsgUserDr;
		InputStr += "^" + CSMsgLocDr;
		InputStr += "^" + CSMessage;
		InputStr += "^" + CSIsRead;
		InputStr += "^" + CSReadDate;
		InputStr += "^" + CSReadTime;
		InputStr += "^" + CSReadUserDr;
		InputStr += "^" + MsgDtlID;
		InputStr += "^" + HospID;
	
		var retval  = $m({
			ClassName:"DHCMA.IMP.IPS.IMPMessageSrv",
			MethodName:"UpdateMsg",
			aInputStr:InputStr,
			aSeparete:'^'
		},false);
		return retval;
	};
	
	//获取鼠标所在屏幕位置	   
	function  getMousePos(event) {
		var e = event || window.event;
		var scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
		var scrollY = document.documentElement.scrollTop || document.body.scrollTop;
		var x = e.pageX || e.clientX + scrollX;
		var y = e.pageY || e.clientY + scrollY;
		return y;
	}
	
	
	//疑似指标鼠标提示
	ShowDtlTip = function(aEpisodeID,aindex,aNote) {
		var NoteArr = aNote.split(";");
		var htmlStr ="";
		if (NoteArr.length==1) {
			htmlStr +='<span style="line-height:25px;">'+aNote+"</span>";
		}else {
			for (var index =0; index< NoteArr.length; index++) {
				var Note = NoteArr[index];
				htmlStr +='<span style="line-height:25px;">'+(index+1)+". "+Note+"</span></br>";	
			}
		}
        var MousePos =getMousePos();
        var bootomHigh = window.screen.availHeight-MousePos;  //当前鼠标位置距离底部的高度
        
		htmlStr +='</div>';
		$("#ResultNote"+aEpisodeID+"ind"+aindex).popover({
	        width:'420px',
			content:htmlStr,
			trigger:'hover',
			placement:((bootomHigh>200)? 'bottom':'top'),
			type:'html'
		});
 
		$("#ResultNote"+aEpisodeID+"ind"+aindex).popover('show');  
	}
	
}


