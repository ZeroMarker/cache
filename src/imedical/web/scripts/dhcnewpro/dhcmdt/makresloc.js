//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-08-05
// ����:	   mdtר����ѡ�����
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgName = session['LOGON.USERNAME'];  /// �û�ID
var ID = "";       /// ����ID
var DisGrpID = ""; /// ����ID
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ������ID
	InitPatEpisodeID(); 
	
	/// ��ʼ�����ֿ�����
	InitDisGrpLocArr();
	
	/// ҳ��Button���¼�
	InitBlButton();
	
	/// ��ʼ��ҳ��ѡ����
	InitLocSelect();
	
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){

	ID = getParam("ID");               /// ����ID
	DisGrpID = getParam("DisGrpID");   /// ����ID
}

/// ҳ�� Button ���¼�
function InitBlButton(){

	$("#itemList").on("click",".checkbox",selectItem);
}

/// ѡ����Ŀ
function selectItem(){
	
	if ($(this).is(':checked')){
		/// ѡ����� ������ר����ȫ��ѡ��
		if (this.name == "LocArr"){
			$('[name="ProDoc"][value="'+ this.id +'"]').prop("checked",true);
		}
		/// ѡ��ҽ��
		if (this.name == "ProDoc"){
			if (!$("input[name='LocArr'][id='"+ this.value +"']").is(':checked')){
				$("input[name='LocArr'][id='"+ this.value +"']").prop("checked",true);	
			}
		}
	}else{
		/// ȡ������ ������ר����ȫ��ȡ��
		if (this.name == "LocArr"){
			$('[name="ProDoc"][value="'+ this.id +'"]').prop("checked",false);
		}
		/// ѡ��ҽ��
		if (this.name == "ProDoc"){
			if ($("input[name='ProDoc'][value='"+ this.value +"']:checked").length == 0){
				$("input[name='LocArr'][id='"+ this.value +"']").prop("checked",false);	
			}
		}
	}
	
}

/// ��ʼ�����ֿ�����
function InitDisGrpLocArr(offset){
	
	runClassMethod("web.DHCMDTConsultQuery","JsGetDisGrpLoc",{"GrpID":DisGrpID},function(jsonObject){
		
		if (jsonObject != null){
			InsDisLocArea(jsonObject);
		}
	},'json',false)
}

/// ���ֿ�����
function InsDisLocArea(itemObjArr){
	/// ������
	var htmlstr = '<tr><td style="width:30px" class="center"></td><td style="width:30px" class="center"></td><td></td><td style="width:30px" class="center"></td><td></td><td style="width:30px" class="center"></td><td></td><td style="width:30px" class="center"></td><td></td>';
	for (var i=0; i<itemObjArr.length; i++){
		htmlstr = htmlstr + '<tr><td><input id="'+ itemObjArr[i].id +'" name="LocArr" type="checkbox" class="checkbox" value=""></input></td><td colspan="8" class="tb_td_required" style="border:1px dotted #ccc;">'+ (i + 1) + "��" + itemObjArr[i].text +'</td></tr>';

		/// ��Ŀ
		var itemArr = itemObjArr[i].items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			if(itemArr[j-1].text==LgName){
			  itemhtmlArr.push('<td><input id="'+ itemArr[j-1].value +'" name="ProDoc" type="checkbox" checked="checked" class="checkbox" value="'+ itemObjArr[i].id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
			}else{
				itemhtmlArr.push('<td><input id="'+ itemArr[j-1].value +'" name="ProDoc" type="checkbox" class="checkbox" value="'+ itemObjArr[i].id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
				}
			
			if (j % 4 == 0){
				itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}
		}
		if ((j-1) % 4 != 0){
			var itemfixArr = [];
			var Len = (j-1) % 4;
			for (var m=4; m>Len; m--){
				itemfixArr.push("<td></td><td></td>"); 
			}
			itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + itemfixArr.join("") +'</tr>';
			itemhtmlArr = [];
		}
		htmlstr = htmlstr + itemhtmlstr;
	}
	$("#itemList").append(htmlstr);
}

/// �رյ�������
function TakClsWin(){

	$("#itemList").html("");
	window.parent.$("#mdtWin").window("close");        /// �رյ�������
}

/// ��ȡѡ��Ŀ���
function TakPreLoc(){
	
	var LocArr = [];
	var LocObjArr = $("input[name='ProDoc']:checked");
	for (var n=0; n<LocObjArr.length; n++){
		LocArr.push(LocObjArr[n].value +"^"+ LocObjArr[n].id);
	}
	
	window.parent.$("#LocGrpList").datagrid("reload",{Params:LocArr.join("#")});
	TakClsWin(); /// �رյ�������
}

/// ��ʼ��ҳ��ѡ����
function InitLocSelect(){
	
	var rowData = window.parent.$("#LocGrpList").datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
			if (!$("input[name='LocArr'][id='"+ item.LocID +"']").is(':checked')){
				$("input[name='LocArr'][id='"+ item.LocID +"']").attr("checked",true);
			}
			if (!$("input[name='ProDoc'][id='"+ item.UserID +"']").is(':checked')){
				$("input[name='ProDoc'][id='"+ item.UserID +"']").attr("checked",true);
			}
		}
	})
}

/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){
	
	var Width = document.body.offsetWidth;
	var Height = document.body.scrollHeight;
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
	/// �Զ��ֲ�
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })