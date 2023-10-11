/**
 * �޶�ά��-ȫ��ҽ��
 * dhcpe.premanager.edit.js
 * @Author   wangguoying
 * @DateTime 2021-10-12
 */

/**  ȫ�ֱ��� */
var _Calendar = null;
var _EditAgeRows = []; //�������б༭��¼
var _EditMoneyRows = []; //�������б༭��¼

/**��������ɾ������**/
Array.prototype.remove = function(val) { 
	var index = this.indexOf(val); 
	if (index > -1) { 
		this.splice(index, 1); 
	} 
};


function init() {
	init_calendar();
}

/**
 * [��ʼ������]
 * @Author   wangguoying
 * @DateTime 2021-10-13
 */
function init_calendar() {
	var calendarEl = document.getElementById('calendar');
	_Calendar = new FullCalendar.Calendar(calendarEl, {
		headerToolbar: {
			left: 'prevYear,prev,next,nextYear today',
			center: 'title',
			right: 'dayGridMonth,timeGridWeek,timeGridDay,list'
		},
		dayCellClassNames: function(dateInfo) { //��Ԫ����Ⱦ����
			if (dateInfo.isPast) return "expire-cell";
		},
		dayCellDidMount: function(arg) {
			if (arg.isPast) {
				var tdBg = $(arg.el).find(".fc-daygrid-day-bg");
				tdBg.html("<div style='text-align:center;color: #ccc;'>�ѹ���</div>");
				arg.isDisabled = true;
			}
		},
		locale: "zh-cn", //����
		weekNumbers: true, //��ʾ�ڼ���
		editable: true,
		navLinks: true, //�����ת
		selectable: true,
		selectMirror: true,
		select: function(arg) {
			if (arg.start < new Date()) {
				$.messager.popover({
					msg: "�ѹ���",
					type: "info",
					timeout: 1000
				});
				return; //���켰��ǰ�Ĳ������ٱ༭
			}
			set_edit_win(arg.startStr);
			$("#manager-edit-win").dialog("open");
			//calendar.unselect()
		},
		eventClick: function(arg) {
			set_edit_win(arg.event.startStr);
			$("#manager-edit-win").dialog("open");
		},
		droppable: false, // this allows things to be dropped onto the calendar
		eventAllow: function(dropInfo, draggedEvent) {
			if (dropInfo.start < new Date()) {
				return false
			};
			return false;
		},
		eventOrder: "-title",
		events: 'dhcpe.premanager.eventsjson.csp',
		eventContent: function(arg){
			return { html: "<div>"+arg.event.title+"</div>" }
		}
	});
	_Calendar.render();
}

/**
 * [���ڵ�Ԫ��༭���ڸ�ֵ]
 * @param    {[String]}    dateStr [��ǰ����]
 * @Author   wangguoying
 * @DateTime 2021-10-13
 */
function set_edit_win(dateStr) {
	clean_edit_win();
	$("#manager-edit-win").panel("setTitle", "�޶�ά��<label style='color:yellow;font-weight:600;'>��" + dateStr + ")</label>");
	$("#w_h_dateStr").val(dateStr);
	var info = tkMakeServerCall("web.DHCPE.PreManagerExt","GetManagerInfo",dateStr,session["LOGON.CTLOCID"]);
	if(info != ""){
		var char0 = String.fromCharCode(0);
		var char1 = String.fromCharCode(1);
		var char2 = String.fromCharCode(2);
		var arrInfo = info.split(char0);
		for(var i=0;i<arrInfo.length;i++){
			var record = arrInfo[i];
			var tmpArr = record.split("^");
			var type = tmpArr[0];
			var status = tmpArr[1];
			status = status.split(char1)[0];
			switch (type) {
				case "T":
					if(status == "Y"){
						$("#w_total_status").switchbox("setValue",true);
					}
					$("#w_total_input").val(tmpArr[2]);
					break;
				case "S":
					if(status == "Y"){
						$("#w_sex_status").switchbox("setValue",true);
					}
					$("#w_male_input").val(tmpArr[2]);
					$("#w_female_input").val(tmpArr[3]);
					break;
				case "IG":
					if(status == "Y"){
						$("#w_gi_status").switchbox("setValue",true);
					}
					$("#w_person_input").val(tmpArr[2]);
					$("#w_group_input").val(tmpArr[3]);
					break;
				case "A":
					if(status == "Y"){
						$("#w_age_status").switchbox("setValue",true);
					}
					var list = record.split(char1)[1];
					var listArr = list.split(char2);
					var rows = [];
					for(var k=0;k<listArr.length;k++){
						var data = listArr[k];
						var dataArr = data.split("^");
						rows.push({
							TOp: "EDIT",
							TID: dataArr[0],
							TMin: dataArr[1],
							TMax: dataArr[2],
							TNum: dataArr[3]
						});
					}
					$("#w_age_grid").datagrid("loadData",rows);
					break;
				case "M":
					if(status == "Y"){
						$("#w_money_status").switchbox("setValue",true);
					}
					var list = record.split(char1)[1];
					var listArr = list.split(char2);
					var rows = [];
					for(var k=0;k<listArr.length;k++){
						var data = listArr[k];
						var dataArr = data.split("^");
						rows.push({
							TOp: "EDIT",
							TID: dataArr[0],
							TMin: dataArr[1],
							TMax: dataArr[2],
							TNum: dataArr[3]
						});
					}
					$("#w_money_grid").datagrid("loadData",rows);
					break;
				default:
					break;
			}
		}
	}
}


function clean_edit_win(){
	$("#w_total_status").switchbox("setValue",false);
	$("#w_total_input").val("");
	$("#w_sex_status").switchbox("setValue",false);
	$("#w_male_input").val("");
	$("#w_female_input").val("");
	$("#w_gi_status").switchbox("setValue",false);
	$("#w_person_input").val("");
	$("#w_group_input").val("");
	$("#w_age_status").switchbox("setValue",false);
	$("#w_age_grid").datagrid("loadData",[]);
	$("#w_money_status").switchbox("setValue",false);
	$("#w_money_grid").datagrid("loadData",[]);
}

/**
 * [��ʽ���༭���� ��������]
 * @Author   wangguoying
 * @DateTime 2021-10-13
 */
function formatter_win_grid(gridId, value, row, index) {
	var btn = "<a href='#' onclick='edit_grid_row(\""+gridId+"\"," + index + ")'>\
				<img style='padding-top:4px;' title='�޸ļ�¼' alt='�޸ļ�¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png' border=0/>\
				</a>";
	if (value == "SAVE") {
		btn = "<a href='#' onclick='edit_grid_row(\""+gridId+"\"," + index + ")'>\
				<img style='padding-top:4px;' title='�����¼' alt='�����¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/save.png' border=0/>\
				</a>";
	}
	return btn + "<a href='#' onclick='delete_grid_row(\""+gridId+"\"," + index + ")'>\
					<img style='margin-left:8px; padding-top:4px;' title='ɾ����¼' alt='ɾ����¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
					</a>";
}

/**
 * [�༭�����]
 * @param    {[String]}    gridId [���ID]
 * @param    {[Int]}    index  [������]
 * @Author   wangguoying
 * @DateTime 2021-10-14
 */
function edit_grid_row(gridId,index){
	var flag =  "EDIT",operation = "SAVE" ; //������ʽ��Ĭ�ϱ༭
	if((gridId == "w_age_grid" && _EditAgeRows.indexOf(index) > -1) || (gridId == "w_money_grid" && _EditMoneyRows.indexOf(index) > -1)){
		flag = "SAVE";
		operation = "EDIT";
	}
	if(flag == "SAVE"){
		$("#"+gridId).datagrid("endEdit",index);
		var data = $("#"+gridId).datagrid("getRows")[index];
		var minV = data.TMin;
		var maxV = data.TMax;
		var num = data.TNum;
		var vaild = true;
		if(parseFloat(minV) > parseFloat(maxV) || (minV == "" && maxV == "")){
			$.messager.popover({msg:"���޲��ܴ�������",type:"error"});
			vaild = false;
		}
		if(num == ""){
			$.messager.popover({msg:"�޶��Ϊ��",type:"error"});
			vaild = false;
		}
		if(!vaild){
			$("#"+gridId).datagrid("beginEdit",index);
			return false;
		}
		if(gridId == "w_age_grid") _EditAgeRows.remove(index);
		if(gridId == "w_money_grid") _EditMoneyRows.remove(index);
	}
	var data = $("#"+gridId).datagrid("getRows");
	data[index].TOp = operation;
	$("#"+gridId).datagrid("loadData",data);

	if(flag == "EDIT"){
		$("#"+gridId).datagrid("beginEdit",index);
		if(gridId == "w_age_grid") _EditAgeRows.push(index);
		if(gridId == "w_money_grid") _EditMoneyRows.push(index);
	}
	
}

/**
 * [ɾ�������]
 * @param    {[String]}    gridId [���ID]
 * @param    {[Int]}    index  [������]
 * @Author   wangguoying
 * @DateTime 2021-10-14
 */
function delete_grid_row(gridId,index){
	var row = $("#"+gridId).datagrid("getRows")[index];
	var id = row.TID;
	if(id != ""){	//id����ʱ��ֱ��ɾ����̨
		var ret = tkMakeServerCall("User.DHCPEPreManagerDetail","Delete",id);
		if(parseInt(ret)!=0){
			$.messager.popover({
				msg: "ɾ��ʧ�ܣ�"+ret.split("^")[1],
				type: 'error'
			});
			return false;
		}else{
			$.messager.popover({
				msg: "��ɾ��",
				type: 'success'
			});
		}
	}
	$("#"+gridId).datagrid("deleteRow",index);
	if(gridId == "w_age_grid") _EditAgeRows.remove(index);
	if(gridId == "w_money_grid") _EditMoneyRows.remove(index);
}

/**
 * [��� ������]
 * @Author   wangguoying
 * @DateTime 2021-10-14
 */
function add_grid_row(gridId) {
	var existNoSave = false;
	if((gridId == "w_age_grid" && _EditAgeRows.length > 0) || (gridId == "w_money_grid" && _EditMoneyRows.length > 0)){
		existNoSave = true;
	}
	if (existNoSave) {
		$.messager.popover({
			msg: "����δ����ļ�¼���뱣������",
			type: 'error'
		});
		return;
	}
	$('#'+gridId).datagrid('appendRow', {
		TOp: 'SAVE',
		TID: '',
		TMin: '',
		TMax: '',
		TNum: ''
	});
	var lastIndex = $('#'+gridId).datagrid('getRows').length - 1;
	$('#'+gridId).datagrid('selectRow', lastIndex);
	$('#'+gridId).datagrid('beginEdit', lastIndex);
	if(gridId == "w_age_grid") _EditAgeRows.push(lastIndex);
	if(gridId == "w_money_grid") _EditMoneyRows.push(lastIndex);
}

/**
 * [�������Ű���Ϣ]
 * @Author   wangguoying
 * @DateTime 2021-10-14
 */
function update_premanager() {
	if(_EditAgeRows.length > 0 || _EditMoneyRows.length > 0){
		$.messager.popover({
			msg: "����δ����ļ�¼���뱣������",
			type: 'error'
		});
		return false;
	}
	var dateStr = $("#w_h_dateStr").val();
	var char0 = String.fromCharCode(0);
	var char1 = String.fromCharCode(1);
	var char2 = String.fromCharCode(2);
	var totalStatus = $("#w_total_status").switchbox("getValue");
	totalStatus = totalStatus ? "Y" : "N";
	var totalNum = $("#w_total_input").val();
	if(totalStatus == "Y" && totalNum == ""){
		$.messager.popover({
			msg: "���������޶��������Ϊ��",
			type: 'error'
		});
		return false;
	}

	var sexStatus = $("#w_sex_status").switchbox("getValue");
	sexStatus = sexStatus ? "Y" : "N";
	var maleNum = $("#w_male_input").val();
	var femaleNum = $("#w_female_input").val();
	var giStatus = $("#w_gi_status").switchbox("getValue");
	giStatus = giStatus ? "Y" : "N";
	var personNum = $("#w_person_input").val();
	var groupNum = $("#w_group_input").val();
	var inString = "T^" + totalStatus + "^" + totalNum;	//�������޶�
	inString += char0 + "S^" + sexStatus + "^" + maleNum + "^" + femaleNum;	//���Ա��޶�
	inString += char0 + "IG^" + giStatus + "^" + personNum + "^" + groupNum;	//���Ա��޶�

	var ageInfo = "";
	var ageStatus = $("#w_age_status").switchbox("getValue");
	ageStatus = ageStatus ? "Y" : "N";
	var ageRows = $("#w_age_grid").datagrid("getRows");
	ageRows.forEach( function(element, index) {
		var str = element.TID + "^" + element.TMin + "^" + element.TMax +"^" + element.TNum;
		ageInfo = ageInfo == "" ? str : ageInfo + char2 + str;
	}); 
	ageInfo = "A^" + ageStatus + char1 + ageInfo;

	var moneyInfo = "";
	var moneyStatus = $("#w_money_status").switchbox("getValue");
	moneyStatus = moneyStatus ? "Y" : "N";
	var moneyRows = $("#w_money_grid").datagrid("getRows");
	moneyRows.forEach( function(element, index) {
		var str = element.TID + "^" + element.TMin + "^" + element.TMax +"^" + element.TNum;
		moneyInfo = moneyInfo == "" ? str : moneyInfo + char2 + str;
	}); 
	moneyInfo = "M^" + moneyStatus + char1 + moneyInfo;
	inString += char0 + ageInfo + char0 + moneyInfo; 

	if(giStatus == "Y" && moneyStatus == "Y"){
		$.messager.popover({
			msg: "���ո����밴�ս���ͬʱ���ã�",
			type: 'error'
		});
		return false;
	}
	var ret = tkMakeServerCall("web.DHCPE.PreManagerExt","Update",dateStr,inString,session["LOGON.CTLOCID"],session["LOGON.USERID"]);
	if(parseInt(ret) < 0){
		$.messager.popover({
			msg: "����ʧ�ܣ�" + ret.split("^")[1],
			type: 'error'
		});
		return false;
	}else{
		$.messager.popover({
			msg: "���³ɹ�",
			type: 'success'
		});
		$HUI.dialog('#manager-edit-win').close();
		//��������
		_Calendar.refetchEvents();
	}
}

$(init);