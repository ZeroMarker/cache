function toMgSecGrp(groupid)
{
	var rtnValue=tkMakeServerCall("web.DHCMgNurSecGrpComm","getMgSecGrp",groupid);
	return rtnValue;
}
///
///Method Description:获取子页面控件元素
///params:{secGrp:护理安全组，EmrCode:js文件名}
function toMgSecGrpSub(secGrp,EmrCode)
{
	var rtnValue=tkMakeServerCall("web.DHCMgNurSecGrpComm","getPageSubElement",secGrp,EmrCode);
	return rtnValue;
}
function monthComm()
{
	var monthCom = new Ext.form.ComboBox({
		name:'monthCom',
		id:'monthCom',
		tabIndex:'0',
		x:0,y:0,
		height:22,
		width:60,
		xtype:'combo',
		store:new Ext.data.JsonStore({
			data:[{
				desc:'一月',
				id:'Jan'
			},{
				desc:'二月',
				id:'Feb'
			},{
				desc:'三月',
				id:'Mar'
			},{
				desc:'四月',
				id:'Apr'	
			},{
				desc:'五月',
				id:'May'	
			},{
				desc:'六月',
				id:'Jun'	
			},{
				desc:'七月',
				id:'Jul'	
			},{
				desc:'八月',
				id:'Aug'	
			},{
				desc:'九月',
				id:'Sep'	
			},{
				desc:'十月',
				id:'Oct'	
			},{
				desc:'十一月',
				id:'Nov'	
			},{
				desc:'十二月',
				id:'Dec'	
			}],
			fields:['desc','id']
		}),
		displayField:'desc',
		valueField:'id',
		allowBlank:true,
		triggerAction:'all',
		mode:'local',
		value:''
	});
	return monthCom;
}
function funExport(grid)
{
	var xls = new ActiveXObject ("Excel.Application");
	xls.visible =true;  //设置excel为可见
	var xlBook = xls.Workbooks.Add;
	var xlSheet = xlBook.Worksheets(1);
 	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var temp_obj = [];
	//只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示) 
	//临时数组,存放所有当前显示列的下标 
	 for(i=0;i <colCount;i++){ 
		if(cm.isHidden(i) == true){ 
		}else{
			temp_obj.push(i);
		}
	}
	for(i=1;i <=temp_obj.length;i++){
		//显示列的列标题
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i-1]);
		xlSheet.Cells(1,i).Font.Bold = true;//加粗
	}
	var store = grid.getStore();
	var recordCount = store.getCount();
	var view = grid.getView();
	for(i=1;i <=recordCount;i++){
		for(j=1;j <=temp_obj.length;j++){
			//EXCEL数据从第二行开始,故row = i + 1;
			xlSheet.Cells(i + 1,j).Value = view.getCell(i - 1,temp_obj[j - 1]).innerText;
		}
	}
	xlSheet.Columns.AutoFit;
	xls.ActiveWindow.Zoom = 100;
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
  xls=null;
  xlBook=null; 
  xlSheet=null;
}
///季度
function quarterCom()
{
	var quarterCom = new Ext.form.ComboBox({
		name:'quarterCom',
		id:'quarterCom',
		tabIndex:'0',
		x:0,y:0,
		height:22,
		width:60,
		xtype:'combo',
		store:new Ext.data.JsonStore({
			data:[{
				desc:'一季度',
				id:'1'
			},{
				desc:'二季度',
				id:'2'	
			},{
				desc:'三季度',
				id:'3'
			},{
				desc:'四季度',
				id:'4'
			}],
			fields:['desc','id']
		}),
		displayField:'desc',
		valueField:'id',
		allowBlank:true,
		triggerAction:'all',
		mode:'local',
		forceSelection:true,
		value:''
	});
	return quarterCom;
}

/********************* 响应粘贴事件上传图片 结束******************/

// 通过HIS 安全组 判断显示页面控件元素
function renderPageElement() {
	var PageElement = tkMakeServerCall("web.DHCMgNurSecGrpComm", "getPageElement", session['LOGON.GROUPID'], menucode);
	var ElementArray = PageElement.split("^");
	for (var i = 0; i < ElementArray.length; i++) {
		if (Ext.getCmp(ElementArray[i])) {
			Ext.getCmp(ElementArray[i]).show();
		}
	}
}

// 获取所选科室
// 在DHCMGNUR.js和DHCMGNurSSGrp.js定义的SelectLoc
// xukun 2016-01-26
function getLoc() {
	if (this.parent.SelectLoc) {
		return this.parent.SelectLoc;
	} else {
		return "";
	}
}
// 设置科室
// xukun 2016-01-26
function setLoc(loc) {
	this.parent.SelectLoc = loc;
}
// 数字转换(小转大，十以内)
// xukun 2016-03-03
function DigitalCvt(number) {
	var rec = new Array('零', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十');
	if (number <= 10 && number >= 0) {
		return rec[number];
	}
	return;
}

// 组件替换
// Component1 被替换组件
// Component2 替换组件
function replaceComponent(Component1, Component2) {
	var parComponent = Component1.ownerCt;
	Component2.setPosition(Component1.x, Component1.y);
	Component2.setSize(Component1.width, Component1.height);
	parComponent.remove(Component1, true);
	parComponent.add(Component2);
	parComponent.doLayout();
}
function showCont(textid, content) {
	if (!content) {
		content = Ext.getCmp(textid).getValue();
	}
	var showContW = new Ext.Window({
			title : '',
			id : 'Text',
			x : (Width - 700) / 2,
			y : (Height - 550) / 2,
			width : 700,
			height : 550,
			autoScroll : true,
			layout : 'absolute',
			modal : true,
			resizable : false,
			items : [{
					hideLabel : true,
					xtype : 'textarea',
					id : 'content',
					width : '100%',
					height : 480,
					value : content
				}
			],
			buttons : [{
					text : '确定',
					id : 'TextBtn1',
					handler : function () {
						Ext.getCmp(textid).setValue(Ext.getCmp('content').getValue());
						Text[textid] = Ext.getCmp('content').getValue();
						showContW.close();
					}
				}, {
					text : '取消',
					id : 'TextBtn2',
					handler : function () {
						showContW.close();
					}
				}
			]
		});
	showContW.show();
}
// 字符串转数组
// xukun 2016-03-28
function strTranArray(ret) {
	var rec = ret.split('^');
	var array = [];
	var len = rec.length;
	for (var i = 0; i < len; i++) {
		var index = rec[i].indexOf('|');
		array[rec[i].split('|')[0]] = rec[i].substr(index + 1);
	}
	return array;
}

/********************* 响应粘贴事件上传图片 ******************/
function upLoadImg(newSrc, type, flag) {
	var sdate = new Date();
	var sYear = sdate.getFullYear();
	var sMonth = sdate.getMonth() + 1;
	var sDay = sdate.getDate();
	var sHour = sdate.getHours();
	var sMinute = sdate.getMinutes();
	var sSecond = sdate.getSeconds();
	var sExtension = sYear.toString() + sMonth.toString() + sDay.toString() + sHour.toString() + sMinute.toString() + sSecond.toString();
	var savename = userId + sExtension + flag + newSrc.substring(newSrc.lastIndexOf('.'), newSrc.length);
	var filepath = newSrc;
	var ftpServerIP = parseXML() + 'tempimg/' + userId + "/";
	var array = parseXML().split('//');
	var loginname = array[1].split('@')[0].split(':')[0];
	var loginpassword = array[1].split('@')[0].split(':')[1];
	var mn = FtpLoadimg(filepath, ftpServerIP, savename, loginname, loginpassword);
	if (mn == "图片上传成功！") {
		if (type != 'paste')
			contentCKE.setData(contentCKE.getData() + '<img src="' + ftpServerIP + savename + '"/>');
		else
			return ftpServerIP + savename;
	} else if (mn == "图片上传失败！") {
		if (type != 'paste')
			Ext.Msg.alert('提示', mn);
		else
			return '';
	}
}
function parseXML() {
	try //Internet Explorer
	{
		xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
	} catch (e) {
		try //Firefox, Mozilla, Opera, etc.
		{
			xmlDoc = document.implementation.createDocument("", "", null);
		} catch (e) {
			alert(e.message);
			return;
		}
	}
	xmlDoc.async = false;
	var ftpIp = webIP.substring(7, webIP.length);
	xmlDoc.load(webIP + "/dhcmg/ftpupload.xml");
	var elements = xmlDoc.getElementsByTagName("FTP");
	var server = elements[0].getElementsByTagName("server")[0].firstChild.nodeValue;
	var userName = elements[0].getElementsByTagName("user")[0].firstChild.nodeValue;
	var password = elements[0].getElementsByTagName("pwd")[0].firstChild.nodeValue;
	var portID = elements[0].getElementsByTagName("port")[0].firstChild.nodeValue;
	ftpServerIP = "Ftp://" + userName + ":" + password + "@" + server + ":" + portID + "/ftploadimg/";
	return ftpServerIP;
}

var pasteService = function (evt) {
	//所见即所得模式,其他模式就退出
	if (this.mode != 'wysiwyg')
		return;
	var data = evt.data.dataValue;
	var imageMath = new RegExp("src(?:=[^{,},<,>]+)", 'g');
	var img = data.match(imageMath);
	if (img) {
		for (var i = 0; i < img.length; i++) {
			var path = img[i].substr(img[i].indexOf('///') + 3, img[i].length - img[i].indexOf('///') - 4);
			var npath = upLoadImg(path, 'paste', i);
			evt.data.dataValue = evt.data.dataValue.replace(path, npath).replace('file:///', '');

		}
	}
}
/********************* 响应粘贴事件上传图片 结束******************/
