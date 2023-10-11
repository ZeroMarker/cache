//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2020-12-25
// ����:	   ֪ʶ����˲��JS
//===========================================================================================

var areaObj = "", // �������
	rowsObj = "", // �ж���
	textObj = ""; // Ԫ�ض���
var FormID = "";  // ��ID
var o,  // ���񵽵��¼�
    X,  // boxˮƽ���
    Y;  // box��ֱ�߶�
var ItemTypeArr = [{"value":"monHead","text":'������'}, {"value":"monBody","text":'Ŀ¼��'}, {"value":"monDeta","text":'������'}, {"value":"monBase","text":'������'}];
var LineTypeArr = [{"value":"startLine","text":'����'}, {"value":"endLine","text":'β��'}];
/// ҳ���ʼ������
function initPageDefault(){
		
	/// ҳ����Ӧ�¼�
	InitPageEvent();
	
	/// ҳ��DataGrid
	InitBmDetList();
	
	/// ҳ��Ԫ��
	InitComponent();
}

/// ҳ��Ԫ��
function InitComponent(){
	
	/// Ŀ¼����
	$HUI.combobox("#labelType").disable();
}

/// ҳ����Ӧ�¼�
function InitPageEvent(){
	
	/// ����Ԫ��
	$(".itemarea").on("click",".btntexts",function (){
		insHtml($(this).attr("data-val"), $(this).attr("data-txt"), $(this).attr("data-css"), $(this).attr("data-type"));
	});
	
	/// ���¼�
	$(".form").on("click",".row",function (e){
		//$(".temp-area div").removeClass("area-select");
		//$(".row").removeClass("row-select");
		//$(this).addClass('row-select');
		$(this).parent().addClass("area-select").siblings().removeClass("area-select");
		$(this).parent().siblings().find(".row").removeClass("row-select");
		rowsObj = this;
		e.stopPropagation();
	});
	
	/// �����¼�
	$(".form").on("click",".temp-area .area",function (e){
		$(this).addClass("area-select").siblings().removeClass("area-select");
		areaObj = this;
		e.stopPropagation();
	});
	
	/// Ԫ���϶�
	$(".form").on("mousedown",".draggable",function (e){
		getObject($(this),e||event);       //box�����¼�������  e-->FF  window.event-->IE
	});
	
	/// Ԫ������ֵ
	$(".form").on("mousedown",".itemlabel",function (e){
		$("#width").val($(this).width());
		$("#height").val($(this).height());
		$("#content").val($(this).text());
		$("#topmargin").val(parseInt($(this).css("margin-top")));
		$("#leftmargin").val(parseInt($(this).css("margin-left")));
		
		$HUI.combobox("#locLine").setValue($(this).attr("data-valloc")||"");
		
		$(".itemlabel").removeClass("itemlabel-select");
		$(this).addClass('itemlabel-select'); /// .siblings().removeClass("itemlabel-select");
		textObj = this;
		e.stopPropagation();
	});
	
	/// ������������
	$(".form").on('click',".area",function(){
	
		if (typeof $(this).attr("data-area") != "undefined"){
			$HUI.combobox("#area").setValue($(this).attr("data-area"));
			GetRevPluElement($(this).attr("data-area")); /// ���ر�Ԫ��
		}else{
			$HUI.combobox("#area").setValue("");
		}
		
		if ($(this).attr("data-area") == "monBody"){
			/// Ŀ¼����
			$HUI.combobox("#labelType").enable();
			$HUI.combobox("#labelType").setValue($(this).attr("data-areatype"));
		}else{
			$HUI.combobox("#labelType").setValue("");
			$HUI.combobox("#labelType").disable();
		}

	})
	
	/// Ԫ������
	$("input[name='grpname']").on('keydown keyup',function(){
		if (this.id == "width"){
			$(textObj).width(this.value);
		}
		if (this.id == "height"){
			$(textObj).width(this.value);
		}
		if (this.id == "content"){
			$(textObj).find('label').text(this.value);
		}
		if (this.id == "topmargin"){
			$(textObj).css("margin-top",this.value +"px");
		}
		if (this.id == "leftmargin"){
			$(textObj).css("margin-left",this.value +"px");
		}
	})
	
	/// ���� Combobox
	$HUI.combobox("#area",{
		data:ItemTypeArr,
		valueField:'value',
		textField:'text',
		panelHeight:'auto',
		onSelect:function(option){
			
			if (areaObj){
				$(areaObj).attr("data-area", option.value);
			}else{
				$.messager.alert("��ʾ:","����ѡ������","info");
				$HUI.combobox("#area").setValue("");
				return;
			}
			
			if (option.value == "monBody"){
				/// Ŀ¼����
				$HUI.combobox("#labelType").enable();
			}
			
			GetRevPluElement(option.value); /// ���ر�Ԫ��
	    }	
	})
	
	/// Ŀ¼���� Combobox
	$HUI.combobox("#labelType",{
		url:$URL+"?ClassName=web.DHCCKBRevPlugin&MethodName=JsGetRevLibArr",
		valueField:'value',
		textField:'text',
		//panelHeight:'auto',
		onSelect:function(option){
			if (areaObj && ($(areaObj).attr("data-area") == "monBody")){
				$(areaObj).attr("data-areatype", option.value);
			}else{
				$.messager.alert("��ʾ:","����ѡ��Ŀ¼����","info");
				$HUI.combobox("#labelType").setValue("");
			}
	    }	
	})
	
	/// ��ֵλ�� Combobox
	$HUI.combobox("#locLine",{
		data:LineTypeArr,
		valueField:'value',
		textField:'text',
		panelHeight:'auto',
		onSelect:function(option){
			if (textObj && ($(textObj).attr("data-valloc") != "")){
				$(textObj).attr("data-valloc", option.value);
			}else{
				$.messager.alert("��ʾ:","����ѡ��Ԫ�أ�","info");
				$HUI.combobox("#locLine").setValue("");
			}
	    }	
	})
}

/// ������
function row(){
	
	var htmlstr = "";
		htmlstr = htmlstr + '<div class="row"></div>';
	$(areaObj).append(htmlstr)
	
	$(".row").removeClass("row-select");
	$(areaObj).find(".row").addClass("row-select");
}

/// �������
function panel(){
	
	var ID = $("#EditForm").attr("data-id");         /// ��ID
	if (ID == ""){
		$.messager.alert("��ʾ:","�����½�ģ�壡","info");
		return;
	}
	var htmlstr = "";
		htmlstr = htmlstr + '<div class="area" data-area="" data-areatype=""></div>';
	$(".temp-area").append(htmlstr);
}

/// ɾ����
function delrow(){
		
	if (rowsObj){
		$(rowsObj).remove();
	}
}

/// ɾ��Ԫ��
function dellabel(){
	
	if (textObj){
		$(textObj).remove();
	}
}

/// ����Ԫ��
function insHtml(val, txt, css, type){
	
//	var htmlstr = "";
//	htmlstr = htmlstr + '<span class="itemlabel draggable '+ css +'"><label data-id="'+ val +'">'+ txt +'</label></span>';
//	if (rowsObj){
//		$(rowsObj).append(htmlstr);
//	}

	var htmlstr = "";
	if (type == "V"){
		htmlstr = htmlstr + '<span class="itemlabel draggable '+ css +'"><label data-id="'+ val +'">'+ txt +'</label></span>';
	}
	if (type == "K"){
		htmlstr = htmlstr + '<span class="itemlabel draggable '+ css +'"><label data-id="">'+ txt +'��</label></span>';
		htmlstr = htmlstr + '<span class="itemlabel draggable '+ css +'"><label data-id="'+ val +'">'+ txt +'</label></span>';
	}
	if (type == "L"){
		htmlstr = htmlstr + '<span class="itemlabel draggable '+ css +'"><label data-id="">'+ txt +'</label></span>';
	}
	if (rowsObj){
		$(rowsObj).append(htmlstr);
	}
	
}

function getObject(obj,e){    //��ȡ���񵽵Ķ���

	o = obj;
	// document.all��IE��ʹ��setCapture�����󶨣��������FFʹ��Window��������¼��Ĳ�׽
	document.all?o.setCapture() : window.captureEvents(Event.MOUSEMOVE);  
	X = e.clientX - parseInt(o.css("margin-left"));   //��ȡ��ȣ�
	//Y = e.clientY - parseInt(o.css("margin-top"));    //��ȡ�߶ȣ�
}
document.onmousemove = function(dis){    //����ƶ��¼�����
	if(!o){    //���δ��ȡ����Ӧ�����򷵻�
		return;
	}
	if(!dis){  //�¼�
		dis = event ;
	//    dis = arguments[0]||window.event;   //��������Ǿ���FF���޷���ȡ�¼�����˵����ͨ�� arguments[0]��ȡFF�µ��¼�����
	}
	o.css('margin-left',dis.clientX - X +"px");     //�趨box��ʽ������ƶ����ı�
	//o.css('margin-top',dis.clientY - Y + "px");
};
document.onmouseup = function(){    //����ɿ��¼�����
	if(!o){   //���δ��ȡ����Ӧ�����򷵻�
		return;
	}
	// document.all��IE��ʹ��releaseCapture����󶨣��������FFʹ��window��������¼��Ĳ�׽
	document.all?o.releaseCapture() : window.releaseEvents(Event.MOUSEMOVE|Event.MOUSEUP)
	o = '';   //���ն���
};

/// ҳ��DataGrid
function InitBmDetList(){
	
	///  ����columns
	var columns=[[
		{field:'itemId',title:'ID',width:100,hidden:true},
		{field:'itemCode',title:'Code',width:175,align:'center',hidden:true},
		{field:'itemDesc',title:'ģ��',width:175,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		onClickRow: function (rowIndex, rowData) {
			
			InsEditForm(rowData.itemId);      /// ���ص�ǰ��
			GetRevPluginHtml(rowData.itemId); /// ȡģ��Html
        },
		onLoadSuccess:function(data){
			
			if (FormID == "") return;
			$.each(data.rows,function(index, item){
          		if (item.itemId == FormID){
	          		$('#bmDetList').datagrid("selectRow", index);
	          		return false;
	          	}
  			})
  			InsEditForm(FormID);      /// ���ص�ǰ��
			GetRevPluginHtml(FormID); /// ȡģ��Html
			FormID = "";
		}
	};
	/// ��������
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCCKBRevPlugin&MethodName=JsGetRevPlugin&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// �������
function setCellLabel(value, rowData, rowIndex){
	
	var html = "";
	return html;
}

/// ����
function savePTemp(){
	
	$(".temp-area div").removeClass("row-select");   /// ���������ʽ
	$(".row").removeClass("row-select");             /// �������ʽ
	$(".itemlabel").removeClass("itemlabel-select"); /// ���Ԫ����ʽ
		
	var ID = $("#EditForm").attr("data-id");         /// ��ID
	var Html = $(".form .list-item").html();

	runClassMethod("web.DHCCKBRevPlugin","InsHtml",{"_headers":{"X_ACCEPT_TAG":1}, "ID":ID, "Html":Html},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ:","����ɹ���","info");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// ɾ��
function delPTemp(){
	
	var ID = $("#EditForm").attr("data-id");       /// ��ID
	runClassMethod("web.DHCCKBRevPlugin","delRevPlugin",{"ID":ID},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ:","ɾ���ɹ���","info");
			$("#bmDetList").datagrid("reload");
			$(".form .temp-area div").html("");   /// ��Html
		}else{
			$.messager.alert("��ʾ:","ɾ��ʧ�ܣ�","error");
		}
	},'',false)
}

/// Ԥ��
function review(){
	
	var ID = $("#EditForm").attr("data-id");       /// ��ID
	var Link = "dhcckb.review.csp?ID="+ ID;
	window.open (Link, '_blank', 'height=500, width=1000, top=150, left=200, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=n o, status=no') //���Ҫд��һ��
}

/// �½�
function newPTemp(){
	
	EditFlag = 1;   /// ���༭��־
	commonShowWin({
		url:"dhcckb.newplugin.csp",
		title:"�½�",
		width:400,
		height:230
	})
    $(".form .temp-area div").html("");   /// ��Html
}

/// ���ص�ǰ��
function InsEditForm(ID){
	
	runClassMethod("web.DHCCKBRevPlugin","GetRevPluObj",{"ID":ID},function(jsonObj){

		if (jsonObj != ""){
			$("#EditForm").attr("data-id",jsonObj.ID);   /// ��ID
			$("#EditForm").text(jsonObj.Code +"-"+ jsonObj.Desc);  /// ������
		}
	},'json',false)
}

/// ȡģ��Html
function GetRevPluginHtml(ID){
	
	$(".form .temp-area div").html("");   /// ��Html
	runClassMethod("web.DHCCKBRevPlugin","GetRevPluHtml",{"ID":ID},function(jsonString){

		if (jsonString != ""){
			$(".form .list-item").html(jsonString);   /// ��Html
		}else{
			$(".form .list-item").html('<div class="temp-area"></div>');   /// ��Html
		}
	},'',false)
}

/// ˢ���б�
function refresh(ID){
	
	FormID = ID;
	$("#bmDetList").datagrid("reload");   /// ˢ���б�
}

/// ���ر�Ԫ��
function GetRevPluElement(area){
	
	runClassMethod("web.DHCCKBRevPlugin","JsGetRevPluElement",{"area":area},function(jsonObj){

		if (jsonObj){
			InsItemArea(jsonObj);  // ����Ԫ��
		}
	},'json',false)
}

/// ����Ԫ��
function InsItemArea(jsonObjArr){
	
	var htmlstr = '';

	/// ��Ŀ
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=jsonObjArr.length; j++){
		
		itemhtmlArr.push('<td><div class="btntexts" data-val="'+ jsonObjArr[j-1].itemCode +'" data-txt="'+ jsonObjArr[j-1].itemDesc +'" data-css="'+ jsonObjArr[j-1].itemCss +'"  data-type="'+ jsonObjArr[j-1].showType +'">'+ jsonObjArr[j-1].itemDesc +'</div></td>');
		if (j % 3 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 3 != 0){
		
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td></td></tr>';
		itemhtmlArr = [];
	}
	$(".itemarea table").html(itemhtmlstr);
}
			
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
