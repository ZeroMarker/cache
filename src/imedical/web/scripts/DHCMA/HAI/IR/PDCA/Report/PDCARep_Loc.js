//'PDCA报告'-科室
function InitPARepLocWin(obj) {
	//新增Plan整改科室
	obj.AddPlanHtml=function(ID){
		var Html	='<div id="PLocDiv_'+ID+'">'
					+'	<div style="float:left;width:25%;">'
					+'		<span style="width:120px;padding:5px 5px 5px 10px;text-align:right;display:inline-block;"><font color="red">*</font>院感科负责人</span>'
					+'		<input id="txtPHILoc_'+ID+'"type="hidden" value=""><input class="textbox" id="cboPHILoc_'+ID+'" style="width:180px;display:inline;"/>'
					+'	</div>'
					+'	<div style="float:left;width:25%;">'
					+'		<span style="width:120px;padding:5px 5px 5px 10px;text-align:right;display:inline-block;"><font color="red">*</font>整改科室</span>'
					+'		<input class="hisui-combobox textbox" id="cboPLoc_'+ID+'"style="width:180px;"/>'
					+'	</div>'
					+'	<div style="float:left;width:25%;">'
					+'		<span style="width:120px;padding:5px 5px 5px 10px;text-align:right;display:inline-block;"><font color="red">*</font>整改科室负责人</span>'
					+'		<input id="txtPUser_'+ID+'"type="hidden" value=""><input class="textbox" id="cboPUser_'+ID+'" style="width:180px;display:inline;"/>'
					+'	</div>'
					+'	<div style="float:left;width:25%;text-align:right;">'
					+'		<div style="padding-right:10px;"><a href="#" id="Delete_P_'+ID+'"class="icon-cancel">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></div>'
					+'	</div>'
					+'	<div style="clear:both;"></div>'		//清除浮动
					+'	<div class="UpLoad" style="padding:5px 10px 0px 10px;">'
					+'		<input type="file" id="UpLoad_P_'+ID+ '"name="uploadify"/><span id="txtUpLoad_P_'+ID+'"></span>'
					+'	</div>'
					+'	<script type="text/plain" id="Editor_P_'+ID+'"style="border:1px solid #d4d4d4;"></script>'	
					+'</div>';
		$('#PlanLocDiv').append(Html)	
    	$.parser.parse('PLocDiv_'+ID); 
    	
    	InitUser(ID,"cboPHILoc_"+ID,"txtPHILoc_"+ID);	//初始化'院感科责任人'
    	InitLoc("cboPLoc_"+ID)							//初始化'科室'
    	InitUser(ID,"cboPUser_"+ID,"txtPUser_"+ID);		//初始化'科室责任人'
    	
    	obj.InitUpLoad("UpLoad_P_"+ID);					//初始化'文件框'
    	obj.InitEditor('Editor_P_'+ID,"1260","150");	//初始化'富文本编辑框'
    	
    	//初始化'删除'
    	$('#Delete_P_'+ID).click(function (e) {
			$.messager.confirm("提示",'是否删除该整改内容?',function (r) {
				if (r) {
					for(var xInd=0;xInd<obj.PLID;xInd++){
						if(obj.PLList[xInd]==ID){
							obj.PLList[xInd]="";
							break;
						}
					}
					$('#PLocDiv_'+ID).hide();
				}
			});
		})	
		//调整编辑框边距
		$('#PlanLocDiv .edui-container').css('padding','5px 10px 5px 10px');
		//是否启用'文件上传'
		if(obj.IsOpenUpLoad!="1")$('.UpLoad').hide();
	}
	//初始化Plan(计划)
	obj.InitPlanHtml=function(){
		obj.PLList= new Array();		// PlanID列表***
		obj.PLID=0;
		
		//->1.构建Plan面板
		var Html="	<div style='padding:7px 0px 5px 0px;'class='hisui-panel' data-options=\"title:'" +obj.TitleList[obj.TitleID]+"、P(计划与目标)"+ "(标注为*的项目为必填项)',headerCls:'panel-header-gray'\">"
				+"		<div id='PlanLocDiv'></div>"
				+"		<div id='PlanAddDiv' style='padding:3px 10px'>"
				+"			<a id='btnAddPlanLoc' class='hisui-linkbutton'>新增计划</a>"
				+"		</div>"
				+"	</div>";
		obj.TitleID++;	
		$('#PlanDiv').html(Html);
    	$.parser.parse('#PlanDiv'); 	// 解析	
		//->2.填充Plan面板
		if(obj.RepID==""){
			obj.AddPlanHtml(1);
		
			obj.PLList[obj.PLID]=1;
			obj.PLID++;
		}
		else{
			//报告关联科室
			for(ind=0;ind<obj.LocList.total;ind++){
				var LocInfo = obj.LocList.rows[ind];
        		var ID=LocInfo.ID;
			
				obj.AddPlanHtml(ID);
			
				obj.PLList[obj.PLID]=ID;
				obj.PLID++;
			}
		}
	}
	//初始化Do(执行)
	obj.InitDoHtml=function(){
		var DoHtml="<div id='DoTabs' class='hisui-tabs tabs-gray' style='padding:false;border-radius:0;'>"
		
		//报告关联科室
		for(ind=0;ind<obj.LocList.total;ind++){
			var LocInfo = obj.LocList.rows[ind];
        	var ID=LocInfo.ID;
			
			var DoHtml	=DoHtml
						+"	<div title='"+LocInfo.PLocDesc+"' style='padding:10px;height:650px;'>"
						+"		<div class='hisui-panel' data-options=\"title:'" +obj.TitleList[obj.TitleID]+"、D(执行)',fit:true,headerCls:'panel-header-gray'\">"
	    				+"			<table class='report-tab'>"
						+"				<tr class='report-tr'>"
						+"					<td class='report-td' style='padding-left:10px;'><font color='red'>*</font>整改实际开始日期</td>"
						+"					<td><input class='hisui-datebox textbox' id='dtDoASttDate_"+ID+"' style='width:150px;' /></td>"			
						+"					<td class='report-td' style='padding-left:10px;'><font color='red'>*</font>整改预计结束日期</td>"				
						+"					<td><input class='hisui-datebox textbox' id='dtDoPEndDate_"+ID+"' style='width:150px;' /></td>	"						
						+"    				<td class='report-td' style='padding-left:10px;'>整改科室/病区</td>"
						+"					<td><input class='textbox readonly-noborder' id='txtDoPLoc_"+ID+"' style='width:150px;font-weight: bold;' /></td>"
						+"    				<td class='report-td' style='padding-left:10px;'>整改责任人</td>"
						+"					<td><input class='textbox readonly-noborder' id='txtDoPUser_"+ID+"' style='width:100px;font-weight: bold;' /></td>"
						+"    				<td class='report-td' style='padding-left:10px;'>提交人</td>"
						+"					<td><input class='textbox readonly-noborder' id='txtDoUser_"+ID+"' style='width:100px;font-weight: bold;' /></td>"
						+"				</tr>"
						+"				<tr style='height:10px;'>"
						+"					<td colspan='10'><span class='line' style='display: block; border-bottom: 1px solid #ccc;margin: 5px;border-bottom-style:dashed;clear:both;'></span></td>"
						+"				</tr>"
						+"				<tr class='UpLoad' style='height:10px;'>"
						+"					<td colspan='10'>"
						+"						<div style='padding-left:10px;'><input class='' type='file' id='UpLoad_D_"+ID+ "'name='uploadify' /><span id='txtUpLoad_D_"+ID+"'></span></div>"
						+"					</td>"
						+"				</tr>"
						+"				<tr class='report-tr'>"	
						+"					<td colspan='10'>"				
						+"						<div><script type='text/plain' id='Editor_D_"+ID+"'style='height:330px;border: 1px solid #d4d4d4;'></script></div>"							
						+"					</td>"	
						+"				</tr>"	
						+"				<tr class='report-tr'>"
						+"					<td class='report-td' style='padding-left:10px;'><font color='red'>*</font>整改结束日期</td>"
						+"					<td><input class='hisui-datebox textbox' id='dtAEndDate_"+ID+"' style='width:153px;' /></td>"									
						+"				</tr>"	
						+"				<tr style='height:10px;'>"
						+"					<td colspan='10'><span class='line' style='display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;'></span></td>"
						+"				</tr>"	
						+"				<tr id='Assess_D_"+ind+"' class='report-tr'>"
						+"					<td class='report-td' style='padding-left:10px;'>科室自评</td>"
						+"					<td colspan='9'><textarea class='textbox' id='txtDoLocAssess_"+ID+"' style='width:1120px;height:170px;' placeholder='请填写科室自评'></textarea></td>"									
						+"				</tr>"		
						+"			</table>"
	    				+"		</div>"
	    				+"	</div>";
		}
		var DoHtml=DoHtml+"</div>";
		obj.TitleID++;	
		
		$('#DoDiv').html(DoHtml);
		$.parser.parse('#DoDiv');
		
		for(ind=0;ind<obj.LocList.total;ind++){
			var LocInfo = obj.LocList.rows[ind];
        	var ID=LocInfo.ID;
        	
			obj.InitUpLoad("UpLoad_D_"+ID);					//初始化'文件框'
    		obj.InitEditor('Editor_D_'+ID,"1255","267");	//初始化'富文本编辑框'
		}
		//调整编辑框边距
		$('#DoDiv .edui-container').css('padding','5px 10px 5px 8px');
	}
	//初始化C+A(检查+评价)
	obj.InitCAHtml=function(){
		var CAHtml="<div id='CATabs' class='hisui-tabs tabs-gray' style='padding:false;border-radius:0;'>"
		
		//报告关联科室
		for(ind=0;ind<obj.LocList.total;ind++){
			var LocInfo = obj.LocList.rows[ind];
        	var ID=LocInfo.ID;
			
			var CAHtml	=CAHtml
						+"		<div id='CADiv_"+ID+"' title='"+LocInfo.PLocDesc+"' style='padding:10px;'>"
						//+"	<div id='CADiv_"+ID+"' title='<span id=\"Tip_C_"+ID+"\">"+LocInfo.PLocDesc+"<span>' style='padding:10px;'>"
						+"		<div style='height:480px;padding-bottom:10px;'>"
						+"			<div class='hisui-panel' data-options=\"title:'" +obj.TitleList[obj.TitleID]+"、C(检查)',fit:true,headerCls:'panel-header-gray'\">"
	    				+"				<table class='report-tab'>"
						+"					<tr class='report-tr'>"								
						+"    					<td class='report-td' style='padding-left:10px;'>整改科室/病区</td>"
						+"							<td><input class='textbox readonly-noborder' id='txtCAPLoc_"+ID+"' style='width:153px;font-weight: bold;' /></td>"
						+"						<td class='report-td' style='padding-left:10px;'>检查日期</td>"
						+"						<td><input class='textbox readonly-noborder' id='txtCheckDate_"+ID+"' style='width:153px;font-weight: bold;' /></td>"
						+"    					<td class='report-td' style='padding-left:10px;'><font color='red'>*</font>检查人</td>"
						+"						<td><input class='textbox' id='txtCheckUser_"+ID+"' style='width:153px;font-weight: bold;' /></td>"
						+"						<td class='report-td' style='padding-left:10px;'>查看报表</td>"
						+"						<td><a href='#' onclick=\"obj.OpenChart()\"><span id='txtRepName_"+ID+"'></span></a></td>"
						+"					</tr>"
						+"					<tr style='height:10px;'>"
						+"						<td colspan='8'><span class='line' style='display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;'></span></td>"
						+"					</tr>"
						+"					<tr class='report-tr'>"	
						+"						<td colspan='8' style='padding:0px 10px 0px 10px;'>"	
						+"							<div id='EchartDiv"+ID+"' style='width:1245px;height:350px;margin-bottom:6px;' placeholder='统计图'></div>"									
						+"						</td>"	
						+"					</tr>"		
						+"				</table>"
	    				+"			</div>"
	    				+"		</div>"
	    				+"		<div style='height:250px;'>"
	    				+"			<div class='hisui-panel' data-options=\"title:'" +obj.TitleList[obj.TitleID+1]+"、A(评价与改进)',fit:true,headerCls:'panel-header-gray'\">"
	    				+"				<table class='report-tab'>"
						+"					<tr class='report-tr'>"								
						+"    					<td class='report-td' style='padding-left:10px;'><font color='red'>*</font>效果评价</td>"
						+"						<td><input class='hisui-combobox textbox' id='cboAssess_"+ID+"' style='width:213px;' /><a href='#' onclick='obj.OpenRepHis()'>(历次数据)</a></td>"
						+"					</tr>"
						+"					<tr style='height:10px;'>"
						+"						<td colspan='6'><span class='line' style='display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;'></span></td>"
						+"					</tr>"
						+"					<tr class='report-tr'>"	
						+"						<td class='report-td' style='padding-left:10px;'>持续改进</td>"
						+"						<td colspan='5'><textarea class='textbox' id='txtAssessIMP_"+ID+"' style='width:1160px;height:145px;margin-bottom:6px;' placeholder='请填写科室自评'></textarea></td>"									
						+"					</tr>"		
						+"				</table>"
	    				+"			</div>"
	    				+"		</div>"
	    				+"	</div>";
		}
		var CAHtml=CAHtml+"</div>";
		obj.TitleID=obj.TitleID+2;	
		
   	 	$('#CADIV').html(CAHtml)	
    	$.parser.parse('#CADIV'); 
    	
    	for(ind=0;ind<obj.LocList.total;ind++){
			var LocInfo = obj.LocList.rows[ind];
        	var ID=LocInfo.ID;
    		
    		//初始化'评价'下拉框
	    	$HUI.combobox("#cboAssess_"+ID, {
				url:$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+"PDCAAccess"+"&aActive=1",
				editable: false,       
				defaultFilter:4,
				allowNull: true,    
				valueField: 'ID',
				textField: 'DicDesc'
			});	
    	}
	}
	//加载'科室P->D->C->A数据'
	obj.LoadPDCA=function(){
		for(ind=0;ind<obj.LocList.total;ind++){
			var LocInfo = obj.LocList.rows[ind];
        	var ID=LocInfo.ID;
        	//加载报告状态
        	if(ID==obj.SubID){
	        	$('#txtStatus').val(LocInfo.ReStatus);
	        	obj.RepStatusCode=LocInfo.StatusCode;
	        }
        	
        	//加载-计划(Plan)
			$('#cboPHILoc_'+ID).lookup("setText",LocInfo.PAdminUserDesc);	//院感科负责人
            $('#txtPHILoc_'+ID).val(LocInfo.PAdminUserID)
            $('#cboPLoc_'+ID).combobox('setValue',LocInfo.PLocID);			//整改科室
            $('#cboPLoc_'+ID).combobox('setText',LocInfo.PLocDesc);
            $('#cboPUser_'+ID).lookup("setText",LocInfo.PLocUserDesc);		//科室负责人
            $('#txtPUser_'+ID).val(LocInfo.PLocUserID)
            //$('#txtUpLoad_P_'+ID).val();									//上传文件列表(注:待补充)
            var EditData=obj.GetEditorData(LocInfo.PData,"2");				//编辑框数据(转换特殊字符)
            UM.getEditor('Editor_P_'+ID).setContent(EditData, false);
            //加载-执行(Do)
            $("#dtDoASttDate_"+ID).datebox('setValue',LocInfo.DASttDate);	//实际开始日期
           	$("#dtDoPEndDate_"+ID).datebox('setValue',LocInfo.DPEndDate);	//预计结束日期
            $('#txtDoPLoc_'+ID).val(LocInfo.PLocDesc);						//整改科室
            $('#txtDoPUser_'+ID).val(LocInfo.PLocUserDesc);					//院感科负责人
            $('#txtDoUser_'+ID).val(LocInfo.DUserDesc);						//科室负责人
           	//$('#txtUpLoad_D_'+ID).val();									//上传文件列表(注:待补充)
            var EditData=obj.GetEditorData(LocInfo.DData,"2");				//编辑框数据(转换特殊字符)
           	UM.getEditor('Editor_D_'+ID).setContent(EditData,false);			
           		
            $("#dtAEndDate_"+ID).datebox('setValue',LocInfo.DAEndDate);		//实际结束日期
            $('#txtDoLocAssess_'+ID).val(LocInfo.DLocAssess);				//科室自评
            
            //加载-检查(C)
            $('#txtCAPLoc_'+ID).val(LocInfo.PLocDesc);						//整改科室
            $('#txtCheckDate_'+ID).val(LocInfo.CDate);						//检查日期
           	$('#txtCheckUser_'+ID).val(LocInfo.CUserDesc);					//检查人
           	$('#txtRepName_'+ID).html(obj.RepName);							//关联报表
           	
            //加载-评价(A)
            $('#cboAssess_'+ID).combobox('setValue',LocInfo.AID);			//评价
            $('#cboAssess_'+ID).combobox('setText',LocInfo.ADesc);
            $('#txtAssessIMP_'+ID).val(LocInfo.AIMP);						//科室自评
		}
	}
	
	//->保存'科室Plan数据'
	obj.SavePlan=function(SatusID){
		var InputStr_P="";
		
		for(ind=0;ind<obj.PLList.length;ind++){
			var ID = obj.PLList[ind];
			if(ID=="")continue;
        	
        	var Parref=obj.RepID;
        	var ChildSub=(Parref=="")?"":ID;	
			var PlanLocID = $('#cboPLoc_'+ID).combobox('getValue');		//整改科室
			var PlanUserID = $('#txtPUser_'+ID).val();					//整改科室负责人
			var PlanHILocID = $('#txtPHILoc_'+ID).val();				//院感科负责人
			var PlanData=UM.getEditor('Editor_P_'+ID).getContent();		//编辑框数据
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
			var InputStr_P=InputStr_P+CHR_2;
			var InputStr_P=InputStr_P+Parref;
			var InputStr_P=InputStr_P+CHR_1+ChildSub;
			var InputStr_P=InputStr_P+CHR_1+PlanLocID;
			var InputStr_P=InputStr_P+CHR_1+PlanUserID;
			var InputStr_P=InputStr_P+CHR_1+PlanHILocID;
			var InputStr_P=InputStr_P+CHR_1+PlanData;
			
			var InputStr_P=InputStr_P+CHR_1+SatusID;	//状态
			var InputStr_P=InputStr_P+CHR_1+"1";		//是否有效(默认有效)
		}
		return InputStr_P;
	}
	//->保存'科室Do数据'
	obj.SaveDo=function(SatusID){
		var Parref=obj.RepID;
        var ChildSub=obj.SubID;	
        
        var ID=ChildSub;
		var DoASttDate=$('#dtDoASttDate_'+ID).datebox('getValue');		//整改实际开始日期
		var DoPEndDate=$('#dtDoPEndDate_'+ID).datebox('getValue');		//整改预计结束日期
		var DoUser=$.LOGON.USERID;										//提交人
		var DoData=UM.getEditor('Editor_D_'+ID).getContent();			//编辑框内容
		DoData=obj.GetEditorData(DoData,"1");
		var DoAEndDate=$('#dtAEndDate_'+ID).datebox('getValue');		//整改实际结束日期
		var DoLocAssess=$('#txtDoLocAssess_'+ID).val();					//科室自评
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
		if((DoAEndDate!="")&&(DoASttDate>DoAEndDate)){
		 	$.messager.alert("提示", "整改实际开始日期不能大于整改实际结束日期！", 'info');
			return false;
		}
		var InputStr_D=Parref;
		var InputStr_D=InputStr_D+CHR_1+ChildSub;
		var InputStr_D=InputStr_D+CHR_1+DoASttDate;
		var InputStr_D=InputStr_D+CHR_1+DoPEndDate;
		var InputStr_D=InputStr_D+CHR_1+DoUser;
		var InputStr_D=InputStr_D+CHR_1+DoData;
		var InputStr_D=InputStr_D+CHR_1+DoAEndDate;
		var InputStr_D=InputStr_D+CHR_1+DoLocAssess;
		
		var InputStr_D=InputStr_D+CHR_1+SatusID;	//状态
		var InputStr_D=InputStr_D+CHR_1+"1";		//是否有效(默认有效)
		
		//->日志信息
        var InputStr_Log=obj.SaveLog(SatusID);
        
		 var Flag = $m({
			ClassName: "DHCHAI.IR.PDCARepLoc",
            MethodName: "UpdateDo",
            aInputStr:InputStr_D,
            aSeparete:CHR_1
        }, false);
		if (parseInt(Flag) > 0) {
           	obj.LoadRep();
           	
            return true;
		}
		else{
            return false;
		}
	}
	//->保存'科室C+A数据'
	obj.SaveCA=function(SatusID){
		var Parref=obj.RepID;
        var ChildSub=obj.SubID;	
        
        var InputStr_CA=Parref;
		var InputStr_CA=InputStr_CA+CHR_1+ChildSub;
		
		var ID=ChildSub;
		var CheckDate="";								//检查日期
		var CheckUser=$('#txtCheckUser_'+ID).val();;	//检查人
		if(CheckUser==""){
		 	$.messager.alert("提示", "检查人不能为空！", 'info');
			return false;
		}	
		
		var InputStr_CA=InputStr_CA+CHR_1+CheckDate;
		var InputStr_CA=InputStr_CA+CHR_1+CheckUser;
		
		var Assess=$('#cboAssess_'+ID).combobox('getValue');	//效果评价
		var AssessIMP=$('#txtAssessIMP_'+ID).val();				//持续改进
		
		var InputStr_CA=InputStr_CA+CHR_1+Assess;
		var InputStr_CA=InputStr_CA+CHR_1+AssessIMP;
		
		var InputStr_CA=InputStr_CA+CHR_1+SatusID;	//状态
		var InputStr_CA=InputStr_CA+CHR_1+"1";		//是否有效(默认有效)
		
		//->日志信息
        var InputStr_Log=obj.SaveLog(SatusID);
        
		 var Flag = $m({
			ClassName: "DHCHAI.IR.PDCARepLoc",
            MethodName: "UpdateCA",
            aInputStr:InputStr_CA,
            aSeparete:CHR_1
        }, false);
		if (parseInt(Flag) > 0) {
           	obj.LoadRep();
           	
            return true;
		}
		else{
            return false;
		}
	}
	//打开报表
	obj.OpenChart=function() {		
		var strUrl = '../csp/'+obj.RepCsp+'?+&1=1';
		websys_showModal({
			url: strUrl,
			title: obj.RepName,
			iconCls: 'icon-w-paper',
			width: '1300',
			height: '90%'
		});
	}
	//打开历史信息
	obj.OpenRepHis=function(){
		obj.gridHistPDCA = $HUI.datagrid("#gridHistPDCA",{
			fit: true,
			iconCls:"icon-resort",
			headerCls:'panel-header-gray',
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: false, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			//nowrap: true, fitColumns: true,     //自动填充整个页面
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
			    ClassName: "DHCHAI.IRS.PDCARegSrvTMP",
		    	QueryName: "QryPARepLoc",
		    	aRepID:obj.RepID,
		    	aLocID:$.LOGON.LOCID,
		   	 	aIsAvtive:"0"
			},
			columns:[[
				{ field: 'RepID', title: 'ID', width: 50, align: 'center' },
				{ field: 'ItemType', title: '项目类型', width: 210, align: 'center' },
				{ field: 'ItemDesc', title: '项目名称', width: 220, align: 'center' },
				{ field: 'IndexDesc', title: '指标名称', width: 220, align: 'center' },
            	{ field: 'RegDate', title: '登记日期', width: 120, align: 'center' },
            	{ field: 'PlanLocDesc', title: '整改科室', width: 150, align: 'center' },
				{ field: 'PlanAdminUserDesc', title: '院感科责任人', width: 150, align: 'center' },
            	{ field: 'PlanLocUserDesc', title: '整改科室责任人', width: 150, align: 'center' },
            	{ field: 'AssessDesc', title: '效果评价', width: 120, align: 'center' },
			]],
			onDblClickRow: function (rowIndex, rowData) {
				if(rowIndex>-1){
			   	 	var aRegTypeID = rowData.RegTypeID;
			    	var aReportID = rowData.ID;

			    	obj.OpenOccView(aRegTypeID, 1, obj.AdminPower,obj.StatusDesc);   //打开职业暴露报告
				}
			},
        	onLoadSuccess: function (data) {
	        	if (data.total > 0) {
	        		dispalyEasyUILoad(); 			//隐藏效果
             		//合并单元格实现表格样式
	    	 		$(this).datagrid("autoMergeCellAndCells", ['RepID','ItemType','ItemDesc','IndexDesc','RegDate']);    	//合并行
            	}
        	}	
		});	
		$('#LayerOpenHistPDCA').show();
		$HUI.dialog('#LayerOpenHistPDCA',{
			title:"操作记录", 
			iconCls:'icon-resort',
			width: 1200,    
			height: 500, 
			modal: true,
			isTopZindex:true
		});
		//极简版-修正边框色值
		if (HISUIStyleCode=="lite"){
 			$('#LayerOpenHistPDCA .panel-body.panel-body-noheader').css("border-color","#E2E2E2");
 		}
	}
	//初始化用户
	function InitUser() {		
		var ID = arguments[0];
		var ItemCode = arguments[1];
		var txtItemCode = arguments[2];
		$("#"+ItemCode).lookup({
			pagination:true,
		    showPageList:false, 
		    showRefresh:false,displayMsg:'',
			loadMsg:'正在查询',
			isCombo:true,		//是否输入字符即触发事件，进行搜索
			minQueryLen:1,		//isCombo为true时，可以搜索要求的字符最小长度
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
			onSelect: function (index,rowData) {
			 	$("#"+txtItemCode).val(rowData['ID']);		//赋值给相关的ID	
				
				//选中'院感科负责人'
			 	if(ItemCode.indexOf("cboPHILoc")>=0){
					InitLoc("cboPLoc_"+ID,rowData['ID']);	//初始化'整改科室'
			 	}
			}
		});
	}
	//初始化整改科室
	function InitLoc() {
		var ItemCode= arguments[0];
		var UserID 	= arguments[1];
		
		//用户关联'科室'[PDCA组]
	 	var LocList = $cm ({
			ClassName:"DHCHAI.IRS.PDCAOtherSrv",
			QueryName:"QryLocGroupUser",
			aUserID:UserID,
			rows:999
		},false);		
		if(LocList.total>0){
			$HUI.combobox("#"+ItemCode, {
				url: $URL,
				editable: true,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'LocDesc2',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.IRS.PDCAOtherSrv';
					param.QueryName = 'QryLocGroupUser';
					param.aUserID = UserID;	
					param.ResultSetType = 'array';
				}
			});	
		}
		else{
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
	}		
}
