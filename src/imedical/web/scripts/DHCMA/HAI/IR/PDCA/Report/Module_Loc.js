function InitPARepWinLoc(obj){//公共方法-加载'用户'
	obj.LocIndexID=0;
    obj.LocIndexList = new Array();
	obj.IndexVal=1;
    obj.LocSubList = new Array();
    
	function Common_LookupToDoc() {		
		var ItemCode = arguments[0];
		var txtItemCode = arguments[1];
		$("#"+ItemCode).lookup({
			panelWidth:220,
			url:$URL,
			editable: true,
			mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
			valueField: 'ID',
			textField: 'UserDesc',
			queryParams:{
				ClassName: 'DHCHAI.BTS.SysUserSrv',
				QueryName: 'QrySysUserList',
				aIsActive: 1
			},
			columns:[[  
				{field:'ID',title:'ID',width:50},
				{field:'UserDesc',title:'姓名',width:150}			
			]],
			onBeforeLoad:function(param){
				var desc=param['q']; 
				param = $.extend(param,{aUserName:desc}); 	//将参数q转换为类中的参数
			},
			pagination:true,
		    showPageList:false, showRefresh:false,displayMsg:'',
			loadMsg:'正在查询',
			isCombo:true,             						//是否输入字符即触发事件，进行搜索
			minQueryLen:1             						//isCombo为true时，可以搜索要求的字符最小长度
		});
		//选中'用户'事件
		$("#"+ItemCode).lookup({
			onSelect: function (index,rowData) {
				var ID=rowData['ID'];
			 	$("#"+txtItemCode).val(ID);           		//给相关的ID赋值
			 	//特殊情况(选中'院感科负责人')
			 	if(ItemCode.indexOf("cboPHILoc")>=0){
				 	//用户关联'PDCA科室'
				 	var LocList = $cm ({
						ClassName:"DHCHAI.IRS.PDCAOtherSrv",
						QueryName:"QryLocGroupUser",
						aUserID:ID,
						rows:999
					},false);
					if(LocList.total>0){
						//刷新'整改科室'
						$HUI.combobox("#cboPLoc_"+index, {
							url: $URL,
							editable: true,
							defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
							valueField: 'ID',
							textField: 'LocDesc2',
							onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
								param.ClassName = 'DHCHAI.IRS.PDCAOtherSrv';
								param.QueryName = 'QryLocGroupUser';
								param.aUserID = ID;	
								param.ResultSetType = 'array';
							}
						});	
					}
				}
			}
		});
	}
	//公共方法-加载'科室'
	function Common_LookupToLoc() {
		var ItemCode = arguments[0];
		//取当前院区组下所有ID	
		var HospList = $cm ({				
			ClassName:"DHCHAI.BTS.HospitalSrv",
			QueryName:"QryHospListByLogon",
			aLogonHospID:$.LOGON.HOSPID
		},false);
		var HospIDs=HospList.rows[0].ID;
		$HUI.combobox("#"+ItemCode, {
			url: $URL,
			editable: true,
			defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
			valueField: 'ID',
			textField: 'LocDesc2',
			onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
				param.ClassName = 'DHCHAI.BTS.LocationSrv';
				param.QueryName = 'QryLoc';
				param.aHospIDs = HospIDs;
				param.aAlias = "";
				param.aLocCate = "";
				param.aLocType = "";
				param.aIsActive = 1;
				param.ResultSetType = 'array';
			}
		});
	}
	//初始化Plan(计划)	
	obj.AddPlanHtml=function(Index){
		var Html	='<div id="PlanLocDiv_'+Index+'"><div style="float:left;width:25%;">'
					+'	<span style="width:120px;padding:5px 5px 5px 10px;text-align:right;display:inline-block;"><font color="red">*</font>院感科负责人:</span>'
					+'	<input id="txtPHILoc_'+Index+'"type="hidden" value=""><input class="textbox" id="cboPHILoc_'+Index+'" style="width:167px;display:inline;"/>'
					+'</div>'
					+'<div style="float:left;width:25%;">'
					+'	<span style="width:120px;padding:5px 5px 5px 10px;text-align:right;display:inline-block;"><font color="red">*</font>整改科室:</span>'
					+'	<input class="hisui-combobox textbox" id="cboPLoc_'+Index+'"style="width:167px;"/>'
					+'</div>'
					+'<div style="float:left;width:25%;">'
					+'	<span style="width:120px;padding:5px 5px 5px 10px;text-align:right;display:inline-block;"><font color="red">*</font>整改科室负责人:</span>'
					+'	<input id="txtPUser_'+Index+'"type="hidden" value=""><input class="textbox" id="cboPUser_'+Index+'" style="width:167px;display:inline;"/>'
					+'</div>'
					+'<div style="float:left;width:25%;text-align:right;">'
					+'	<div style="padding-right:10px;"><a href="#" id="Delete_P_'+Index+'"class="icon-cancel">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></div>'
					+'</div>'
					+'<div style="clear:both;"></div>'		//清除浮动
					+'<div style="padding:5px 10px 0px 10px;"><input type="file" id="UpLoad_P_'+Index+ '"name="uploadify"/><span id="txtUpLoad_P_'+Index+'"></span></div>'
					+'<script type="text/plain" id="Editor_P_'+Index+'"style="border:1px solid #d4d4d4;"></script>'							
					+'<span id="Line_P_'+Index+'"class="line" style="display: block; border-bottom: 1px solid #ccc;margin: 5px;border-bottom-style:dashed;clear:both;"></span></div></div>';
		$('#PlanLocDiv').append(Html)	
    	$.parser.parse('#PlanLocDiv_'+Index); 
    	//初始化'院感科责任人'
    	Common_LookupToDoc("cboPHILoc_"+Index,"txtPHILoc_"+Index);
    	//初始化'整改科室'
    	Common_LookupToLoc("cboPLoc_"+Index);
    	//初始化'整改负责人'
    	Common_LookupToDoc("cboPUser_"+Index,"txtPUser_"+Index);
    	//初始化'文件框'
		obj.LoadUpLoad("UpLoad_P_"+Index);
		//初始化'富文本编辑框'
		obj.LoadEditor('Editor_P_'+Index,"1260","150");
		//初始化'删除事件'
		$('#Delete_P_'+Index).click(function (e) {
			$.messager.confirm("提示", '是否删除该整改内容?', function (r) {
				if (r) {
					$('#PlanLocDiv_'+Index).hide();
				}
			});
		})	
		//调整编辑框边距
		$('#PlanLocDiv .edui-container').css('padding','5px 10px 5px 10px');
	}
	//初始化D(执行)
	obj.LoadDoHtml=function(){
		var DoHtml="";
		//管理员+多个科室->显示页签
		if((obj.Admin==1)&&(obj.LocList.total>1)){
			var DoHtml=DoHtml+"<div id='DoTabs' class='hisui-tabs tabs-gray' style='padding:false;border-radius:0;'>"
		}
		
		for(ind=0;ind<obj.LocList.total;ind++){
			//'非管理员'只允许查看本科室
			if((obj.Admin!=1)&&(obj.LocList.rows[ind].PlanLocID!=$.LOGON.LOCID))continue;
			
			//管理员+多个科室->显示页签
			if((obj.Admin==1)&&(obj.LocList.total>1)){
				var DoHtml=DoHtml+"<div title='"+obj.LocList.rows[ind].PlanLocDesc+"' style='padding:10px;height:650px;'>"
			}
			else{
				var DoHtml=DoHtml+"<div style='padding:10px;height:650px;'>"
			}
			//显示顺序
			var Index=obj.LocList.rows[ind].Index;
			
			var DoHtml	=	DoHtml	
	    				+	"	<div class='hisui-panel' data-options='title:\"五、D(执行)\",fit:true,headerCls:\"panel-header-gray\",tools:[{iconCls:\"icon-clock-record\"}]'>"
	    				+	"		<table class='report-tab'>"
						+	"			<tr class='report-tr'>"
						+	"				<td class='report-td' style='padding-left:10px;'><font color='red'>*</font>"+$g("整改实际开始日期")+"</td>"
						+	"				<td><input class='hisui-datebox textbox' id='dtDoASttDate_"+Index+"' style='width:150px;' /></td>"			
						+	"				<td class='report-td' style='padding-left:10px;'><font color='red'>*</font>"+$g("整改预计结束日期")+"</td>"				
						+	"				<td><input class='hisui-datebox textbox' id='dtDoPEndDate_"+Index+"' style='width:150px;' /></td>	"						
						+	"    			<td class='report-td' style='padding-left:10px;'>"+$g("整改科室/病区")+"</td>"
						+	"				<td><input class='textbox readonly-noborder' id='txtDoPLoc_"+Index+"' style='width:150px;font-weight: bold;' /></td>"
						+	"    			<td class='report-td' style='padding-left:10px;'>"+$g("整改责任人")+"</td>"
						+	"				<td><input class='textbox readonly-noborder' id='txtDoPUser_"+Index+"' style='width:100px;font-weight: bold;' /></td>"
						+	"    			<td class='report-td' style='padding-left:10px;'>"+$g("提交人")+"</td>"
						+	"				<td><input class='textbox readonly-noborder' id='txtDoUser_"+Index+"' style='width:100px;font-weight: bold;' /></td>"
						+	"			</tr>"
						+	"			<tr style='height:10px;'>"
						+	"				<td colspan='10'><span class='line' style='display: block; border-bottom: 1px solid #ccc;margin: 5px;border-bottom-style:dashed;clear:both;'></span></td>"
						+	"			</tr>"
						+	"			<tr class='UpLoad' style='height:10px;'>"
						+	"				<td colspan='10'>"
						+	"					<div style='padding-left:10px;'><input class='' type='file' id='UpLoad_D_"+Index+ "'name='uploadify' /><span id='txtUpLoad_D_"+Index+"'></span></div>"
						+	"				</td>"
						+	"			</tr>"
						+	"			<tr class='report-tr'>"	
						+	"				<td colspan='10'>"				
						+	"					<div><script type='text/plain' id='Editor_D_"+Index+"'style='height:330px;border: 1px solid #d4d4d4;'></script></div>"							
						+	"				</td>"	
						+	"			</tr>"	
						+	"			<tr class='report-tr'>"
						+	"				<td class='report-td' style='padding-left:10px;'><font color='red'>*</font>"+$g("整改结束日期")+"</td>"
						+	"				<td><input class='hisui-datebox textbox' id='dtAEndDate_"+Index+"' style='width:153px;' /></td>"									
						+	"			</tr>"	
						+	"			<tr style='height:10px;'>"
						+	"				<td colspan='10'><span class='line' style='display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;'></span></td>"
						+	"			</tr>"	
						+	"			<tr id='Assess_D_"+ind+"' class='report-tr'>"
						+	"				<td class='report-td' style='padding-left:10px;'>"+$g("科室自评")+"</td>"
						+	"				<td colspan='9'><textarea class='textbox' id='txtDoLocAssess_"+Index+"' style='width:1140px;height:150px;' placeholder='"+$g("请填写科室自评")+"'></textarea></td>"									
						+	"			</tr>"		
						+	"		</table>"
	    				+	"	</div>"
	    				+	"</div>"
		}
		//管理员+多个科室->显示页签
		if((obj.Admin==1)&&(obj.LocList.total>1)){
			var DoHtml=DoHtml+"</div>";
		}
		$('#DoDiv').html(DoHtml);
		$.parser.parse('#DoDiv');
		//处理页签格式问题
    	$('.tabs-panels').css("border","0px")
    
    	for(ind=0;ind<obj.LocList.total;ind++){
			//'非管理员'只允许查看本科室
			if((obj.Admin!=1)&&(obj.LocList.rows[ind].PlanLocID!=$.LOGON.LOCID))continue;
			//显示顺序
			var Index=obj.LocList.rows[ind].Index;
			//
			if(!obj.LocSubID)obj.LocSubID=obj.LocList.rows[ind].ID;	//记录选中'科
			
			//初始化'文件框'
			obj.LoadUpLoad("UpLoad_D_"+Index);
			obj.LoadEditor('Editor_D_'+Index,"1275","267");
		}
		//调整编辑框边距
		$('#DoDiv .edui-container').css('padding','5px 10px 5px 8px');
	}
	//初始化CA(检查评价)
	obj.LoadCAHtml=function(){
		var CAHtml="";
		//管理员+多个科室->显示页签
		if((obj.Admin==1)&&(obj.LocList.total>1)){
			var CAHtml=CAHtml+"<div id='CATabs' class='hisui-tabs tabs-gray' style='padding:false;border-radius:0;'>"
		}
		for(ind=0;ind<obj.LocList.total;ind++){
			//过滤未执行科室
			if(obj.LocList.rows[ind].DoUserID=="")continue;
			
			//显示顺序
			var Index=obj.LocList.rows[ind].Index;
			
			//管理员+多个科室->显示页签
			if((obj.Admin==1)&&(obj.LocList.total>1)){
				var CAHtml=CAHtml+"<div id='CADiv_"+Index+"' title='<span id=\"Tip_C_"+Index+"\">"+obj.LocList.rows[ind].PlanLocDesc+"<span>' style='padding:10px;'>";
			}
			else{
				var CAHtml=CAHtml+"<div style='padding:10px;'>"
			}
			var CAHtml	=CAHtml	
	    				+	"	<div style='height:480px;padding-bottom:10px;'>"
	    				+	"		<div class='hisui-panel' data-options='title:\"五、C(检查)\",fit:true,headerCls:\"panel-header-gray\",tools:[{iconCls:\"icon-clock-record\"}]'>"
	    				+	"			<table class='report-tab'>"
						+	"				<tr class='report-tr'>"								
						+	"    				<td class='report-td' style='padding-left:10px;'>整改科室/病区</td>"
						+	"					<td><input class='textbox readonly-noborder' id='txtCAPLoc_"+Index+"' style='width:153px;font-weight: bold;' /></td>"
						+	"					<td class='report-td' style='padding-left:10px;'>检查日期</td>"
						+	"					<td><input class='textbox readonly-noborder' id='txtCheckDate_"+Index+"' style='width:153px;font-weight: bold;' /></td>"
						+	"    				<td class='report-td' style='padding-left:10px;'>检查人</td>"
						+	"					<td><input class='textbox readonly-noborder' id='txtCheckUser_"+Index+"' style='width:153px;font-weight: bold;' /></td>"
						+	"					<td class='report-td' style='padding-left:10px;'>查看报表</td>"
						+	"					<td><a href='#' onclick=\"OpenChart()\"><span id='txtRepName'>"+obj.RepName+"</span></a></td>"
						+	"				</tr>"
						+	"				<tr style='height:10px;'>"
						+	"					<td colspan='8'><span class='line' style='display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;'></span></td>"
						+	"				</tr>"
						+	"				<tr class='report-tr'>"	
						+	"					<td colspan='8' style='padding:0px 10px 0px 10px;'>"	
						+	"						<div id='EchartDiv"+Index+"' style='width:1245px;height:350px;margin-bottom:6px;' placeholder='统计图'></div>"									
						+	"					</td>"	
						+	"				</tr>"		
						+	"			</table>"
	    				+	"		</div>"
	    				+	"	</div>"
	    				+	"	<div style='height:250px;'>"
	    				+	"		<div class='hisui-panel' data-options='title:\"六、A(评价与改进)\",fit:true,headerCls:\"panel-header-gray\",tools:[{iconCls:\"icon-clock-record\"}]'>"
	    				+	"			<table class='report-tab'>"
						+	"				<tr class='report-tr'>"								
						+	"    				<td class='report-td' style='padding-left:10px;'><font color='red'>*</font>效果评价</td>"
						+	"					<td><input class='hisui-combobox textbox' id='cboAssess_"+Index+"' style='width:213px;' /></td>"
						+	"				</tr>"
						+	"				<tr style='height:10px;'>"
						+	"					<td colspan='6'><span class='line' style='display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;'></span></td>"
						+	"				</tr>"
						+	"				<tr class='report-tr'>"	
						+	"					<td class='report-td' style='padding-left:10px;'>持续改进</td>"
						+	"					<td colspan='5'><textarea class='textbox' id='txtAssessIMP_"+Index+"' style='width:1180px;height:150px;margin-bottom:6px;' placeholder='请填写科室自评'></textarea></td>"									
						+	"				</tr>"		
						+	"			</table>"
	    				+	"		</div>"
	    				+	"	</div>"
	    				+	"</div>";
		}
		//管理员+多个科室->显示页签
		if((obj.Admin==1)&&(obj.LocList.total>1)){
			var CAHtml=CAHtml+"</div>";
		}
   	 	$('#CADIV').html(CAHtml)	
    	$.parser.parse('#CADIV'); 
    	//处理页签格式问题
    	$('#CADIV .tabs-panels').css("border","0px")
    
    	for(ind=0;ind<obj.LocList.total;ind++){
			//过滤未执行科室
			if(obj.LocList.rows[ind].DoUserID=="")continue;
			//显示顺序
			var Index=obj.LocList.rows[ind].Index;
			//刷新统计图
		 	//obj.InitChart("EchartDiv"+ind);
	    	//初始化'评价'下拉框
	    	$HUI.combobox("#cboAssess_"+Index, {
				url:$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+"PDCAAccess"+"&aActive=1",
				editable: false,       
				defaultFilter:4,
				allowNull: true,    
				valueField: 'ID',
				textField: 'DicDesc'
			});	
			//刷新Tip(未评估红色)
			if(obj.LocList.rows[ind].AssessID==""){
				$("#Tip_C_"+Index).css("color","red");
			}
			else{
				$("#Tip_C_"+Index).css("color","black");
			}
		}
	}
	
	//加载'整改科室'数据
	obj.initLocData=function(){
		//科室基本信息
        obj.LocList = $cm({
            ClassName: "DHCHAI.IRS.PDCARepSrv",
            QueryName: "QryPARepLoc",
            aRepID: obj.RepID,
            aIsHist:"0",
            rows: 999
        }, false);
        for(ind=0;ind<obj.LocList.total;ind++){
			var LocInfo = obj.LocList.rows[ind];
        	var Index=LocInfo.Index;
			//Plan
			$('#cboPHILoc_'+Index).lookup("setText",LocInfo.PlanAdminUserDesc);		//院感科负责人(P)
            $('#txtPHILoc_'+Index).val(LocInfo.PlanAdminUserID)
            $('#cboPLoc_'+Index).combobox('setValue',LocInfo.PlanLocID);			//整改科室(P)
            $('#cboPLoc_'+Index).combobox('setText',LocInfo.PlanLocDesc);
            $('#cboPUser_'+Index).lookup("setText",LocInfo.PlanLocUserDesc);		//科室负责人(P)										
            $('#txtPUser_'+Index).val(LocInfo.PlanLocUserID)
            //***$('#txtUpLoad_P__'+Index)											//文件框
            PlanData=obj.GetEditorData(LocInfo.PlanData,"2");						//编辑框(转换特殊字符)
            UM.getEditor('Editor_P_'+Index).setContent(PlanData, false);
			//Do
			//'非管理员'只允许查看本科室
			if((obj.Admin!=1)&&(obj.LocList.rows[ind].PlanLocID!=$.LOGON.LOCID))continue;
			//不允许查看
			if(!$('#dtDoASttDate_'+Index).length>0)continue;	
			
            $("#dtDoASttDate_"+Index).datebox('setValue',LocInfo.DoASttDate);			//开始日期(D)
           	$("#dtDoPEndDate_"+Index).datebox('setValue',LocInfo.DoPEndDate);			//结束日期(D)
            $('#txtDoPLoc_'+Index).val(LocInfo.PlanLocDesc);							//整改科室(D)
            $('#txtDoPUser_'+Index).val(LocInfo.PlanLocUserDesc);						//院感科负责人(D)
            $('#txtDoUser_'+Index).val(LocInfo.DoUserDesc);								//科室负责人(D)
            //***$('#txtUpLoad_D__'+Index)												//文件框
            DoData=obj.GetEditorData(LocInfo.DoData,"2");								//编辑框
            UM.getEditor('Editor_D_'+Index).setContent(DoData, false);				
            $("#dtAEndDate_"+Index).datebox('setValue',LocInfo.DoAEndDate);				//实际开始日期(D)
            $('#txtDoLocAssess_'+Index).val(LocInfo.DoLocAssess);						//科室自评(D)
            //C+A
            //过滤未执行科室
			if(obj.LocList.rows[ind].DoUserID=="")continue;
			//不允许查看
			if(!$('#txtCAPLoc_'+Index).length>0)continue;	
			
			$('#txtCAPLoc_'+Index).val(LocInfo.PlanLocDesc);							//整改科室(C)
            $('#txtCheckDate_'+Index).val(LocInfo.CheckDate);							//检查日期(C)
           	$('#txtCheckUser_'+Index).val(LocInfo.CheckUserDesc);						//检查人(C)
           	$('#cboAssess_'+Index).combobox('setValue',LocInfo.AssessID);				//评价(A)
            $('#cboAssess_'+Index).combobox('setText',LocInfo.AssessDesc);
            $('#txtAssessIMP_'+Index).val(LocInfo.AssessIMP);							//科室自评(A)
		}
	}
	
	//->保存科室信息[P]
	obj.SaveLocP=function(){
		var InputStr_Loc="";
		for(ind=0;ind<obj.LocIndexList.length;ind++){
			var index=obj.LocIndexList[ind];
			//
			if(!$('#PlanLocDiv_'+index).is(":visible"))continue;	
						
			var ChildSub=obj.LocSubList[ind];								//SubID
			var PlanLocID = $('#cboPLoc_'+index).combobox('getValue');		//P-整改科室
			var PlanUserID = $('#txtPUser_'+index).val();					//P-整改科室负责人
			var PlanHILocID = $('#txtPHILoc_'+index).val();					//P-院感科负责人
			var PlanData=UM.getEditor('Editor_P_'+index).getContent();		//P-描述
			PlanData=obj.GetEditorData(PlanData,"1");
			
			if(PlanLocID==""){
			 	$.messager.alert("提示", "整改科室不能为空！", 'info');
				return false;
			}
			if(PlanUserID==""){
			 	$.messager.alert("提示", "整改科室负责人不能为空！", 'info');
				return false;
			}
			if(PlanHILocID==""){
			 	$.messager.alert("提示", "院感科负责人不能为空！", 'info');
				return false;
			}
			var PAIsHist="0";
			
			var InputStr_Loc=InputStr_Loc+CHR_2;
			var InputStr_Loc=InputStr_Loc+CHR_1+ChildSub;
			var InputStr_Loc=InputStr_Loc+CHR_1+PlanLocID;
			var InputStr_Loc=InputStr_Loc+CHR_1+PlanUserID;
			var InputStr_Loc=InputStr_Loc+CHR_1+PlanHILocID;
			var InputStr_Loc=InputStr_Loc+CHR_1+PlanData;
			var InputStr_Loc=InputStr_Loc+CHR_1+PAIsHist;
			var InputStr_Loc=InputStr_Loc+CHR_1+index;
		}
		return InputStr_Loc;
	}
	//->保存科室信息[D]
	obj.SaveLocD=function(){
		var InputStr_Loc="";
		for(ind=0;ind<obj.LocIndexList.length;ind++){
			var index=obj.LocIndexList[ind];
			
			if(!$('#dtDoASttDate_'+index).length>0)continue;	
			
			var ChildSub=obj.LocSubList[ind];								//SubID
			var DoASttDate=$('#dtDoASttDate_'+index).datebox('getValue');	//D-整改开始日期
			var DoPEndDate=$('#dtDoPEndDate_'+index).datebox('getValue');	//D-整改结束日期
			var DoUser=$.LOGON.USERID;										//D-提交人
			var DoData=UM.getEditor('Editor_D_'+index).getContent();		//D-描述
			DoData=obj.GetEditorData(DoData,"1");
			var DoAEndDate=$('#dtAEndDate_'+index).datebox('getValue');		//D-整改实际结束日期
			var DoLocAssess=$('#txtDoLocAssess_'+index).val();				//D-科室自评
			if(DoASttDate==""){
			 	$.messager.alert("提示", "整改实际开始日期不能为空！", 'info');
				return false;
			}
			if(DoPEndDate==""){
			 	$.messager.alert("提示", "整改预计结束日期不能为空！", 'info');
				return false;
			}
			if(DoASttDate>DoPEndDate){
			 	$.messager.alert("提示", "整改实际开始日期不能大于整改预计结束日期！", 'info');
				return false;
			}
			if(DoASttDate>DoAEndDate){
			 	$.messager.alert("提示", "整改实际开始日期不能大于整改结束日期！", 'info');
				return false;
			}
			
			var InputStr_Loc=InputStr_Loc+CHR_2;
			var InputStr_Loc=InputStr_Loc+CHR_1+ChildSub;
			var InputStr_Loc=InputStr_Loc+CHR_1+DoASttDate;
			var InputStr_Loc=InputStr_Loc+CHR_1+DoPEndDate;
			var InputStr_Loc=InputStr_Loc+CHR_1+DoUser;
			var InputStr_Loc=InputStr_Loc+CHR_1+DoData;
			var InputStr_Loc=InputStr_Loc+CHR_1+DoAEndDate;
			var InputStr_Loc=InputStr_Loc+CHR_1+DoLocAssess;
			var InputStr_Loc=InputStr_Loc+CHR_1+index;
		}
		return InputStr_Loc;
	}
	//->保存科室信息[CA]
	obj.SaveLocCA=function(){
		var InputStr_Loc="";
		for(ind=0;ind<obj.LocIndexList.length;ind++){
			var index=obj.LocIndexList[ind];
			
			if(!$('#cboAssess_'+index).length>0)continue;	
			
			var ChildSub=obj.LocSubList[ind];								//SubID
			var CheckDate="";												//C-检查日期
			var CheckUser=$.LOGON.USERID;									//C-检查人
			var Assess=$('#cboAssess_'+index).combobox('getValue');			//A-效果评价
			var AssessIMP=$('#txtAssessIMP_'+index).val();					//A-持续改进
			var Index=ind;
			
			var InputStr_Loc=InputStr_Loc+CHR_2;
			var InputStr_Loc=InputStr_Loc+CHR_1+ChildSub;
			var InputStr_Loc=InputStr_Loc+CHR_1+CheckDate;
			var InputStr_Loc=InputStr_Loc+CHR_1+CheckUser;
			var InputStr_Loc=InputStr_Loc+CHR_1+Assess;
			var InputStr_Loc=InputStr_Loc+CHR_1+AssessIMP;
			var InputStr_Loc=InputStr_Loc+CHR_1+index;
		}
		return InputStr_Loc;
	}
}
//打开报表
function OpenChart(){
	var strUrl = '../csp/'+obj.RepCsp+'?+&1=1';
	websys_showModal({
		url: strUrl,
		title: obj.RepName,
		iconCls: 'icon-w-paper',
		width: '1300',
		height: '90%'
	});
}