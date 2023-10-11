var PageLogicObj = {
    m_StrFlag: "", //�ַ�������
    m_Compact: "", //�Ƿ�ѹ��
    m_KeyArr: [], //������Ĺؼ���
    m_ParseArr: [] //�����������
}

$(function() {
    Init();
    InitPage();
    InitEvent();
})

function Init() {
    //return;
    ChangeButtonText("#JsonOnline", "icon-big-book-eye", "JSON���߽���");
    ChangeButtonText("#XMLOnline", "icon-big-open-eye", "XML���߽���");
    ChangeButtonText("#TransStr", "icon-big-book-to-book", "תM�ַ���");
    ChangeButtonText("#TransObj", "icon-big-slide-send", "תM����");
    ChangeButtonText("#FormaterStr", "icon-big-card", "��ʽ��");
    ChangeButtonText("#GetTabData", "icon-big-paper-pen", "����ȡֵ");
    ChangeButtonText("#Help", "icon-big-tip", InitTip());
}

function InitPage() {
    InitTabNameCombobox();
    if (ServerObj.OpenTabFlag=="Y"){
		ShowGetTabData();
	}
}

function InitEvent() {
    $("#JsonOnline").click(JsonOnlineClick);
    $("#XMLOnline").click(XMLOnlineClick);
    $("#TransStr").click(TransStrClick);
    $("#TransObj").click(TransObjClick);
    $("#FormaterStr").click(FormaterClick);
    $("#Help").popover({ title: '', content: InitTip() });
    $("#GetTabData").click(ShowGetTabData);
    $("#FindTabData").click(LoadTreeDataGrid);
    $("#SaveTabData").click(SaveTabData);
    $(document.body).bind("keydown", BodykeydownHandler);
}
// Json���߽���
function JsonOnlineClick() {
    window.open('https://www.sojson.com/simple_json.html');
}
// XML���߽���
function XMLOnlineClick() {
    window.open('https://www.bejson.com/xml2json/');
}
// תM�ַ���
function TransStrClick() {
    var Str = $("#w-str").val();
    Str = ReplaceStr(Str);
    var First = Str.substr(0, 1);
    var Query = $('#Query').checkbox('getValue');
    if (Query) {
        PageLogicObj.m_ParseArr = [];
        PageLogicObj.m_KeyArr = [];
        if (("<{[").indexOf(First) == "-1") {
            GetSortObjByStr(Str);
        } else {
            if (First == "<") {
                var x2js = new X2JS();
                var Obj = x2js.xml_str2json(Str);
                PageLogicObj.m_StrFlag = "XML"
            } else {
                var Obj = JSON.parse(Str);
                PageLogicObj.m_StrFlag = "JSON"
            }
            GetSortObjByObj(Obj);
        }
	var GNote = $('#GNote').checkbox('getValue');
        var OutStr = "";
        var QueryStr = "";
        var LineArr = PageLogicObj.m_KeyArr;
        for (var Line = 0; Line < LineArr.length; Line++) {
            var Key = LineArr[Line].text || "";
            if (Key == "") continue;
            var TKey = Key.replace(/ |_/g, "");
            var Note = LineArr[Line].note;
            if (!GNote) Note="";
            OutStr += (Line > 0 ? "," : "") + TKey;
            QueryStr += (Line > 0 ? "," : "") + Key + ":%String" + (Note != "" ? (":" + Note) : "");
        }
        Str = "s Data=$lb(" + OutStr + ")\n\n\n" + QueryStr;
    } else {
        if (("{[").indexOf(First) >= 0) {
            //Jsonz�е�" �滻Ϊm��""
            Str = Str.replace(/"/g, '""');
        }
        Str = '"' + Str + '"';
    }
    $("#e-obj").attr("wrap", "on");
    $("#e-obj").val(Str);
}
// תM����
function TransObjClick() {
    try {
        $("#e-obj").val("");
        var Str = $("#w-str").val();
        Str = ReplaceStr(Str);
        if (Str == "") {
            $("#e-obj").val("��������Ч���ַ�����");
            $("#w-str").focus();
            return false;
        }
        PageLogicObj.m_ParseArr = [];
        PageLogicObj.m_KeyArr = [];
        var ObjStr = LastStr = ReStr = PreStr = "";
        var First = Str.substr(0, 1);
        if (("<{[").indexOf(First) == "-1") {
            PageLogicObj.m_StrFlag == "";
            GetSortObjByStr(Str);
        } else {
            if (First == "<") {
                var x2js = new X2JS();
                var Obj = x2js.xml_str2json(Str);
                PageLogicObj.m_StrFlag = "XML"
            } else {
                var Obj = JSON.parse(Str);
                PageLogicObj.m_StrFlag = "JSON"
            }
            GetSortObjByObj(Obj);
        }
        var ObjStr = GetMObjStr();
        if (ObjStr) {
            $("#e-obj").attr("wrap", "off");
            $("#e-obj").val(ObjStr);
        }
        PageLogicObj.m_StrFlag == "";
    } catch (e) {
        $("#e-obj").val(e.message);
        console.log(e);
    }
}
// ͨ���ַ�����ȡ�µ�˳�����
function GetSortObjByStr(Str) {
    var KeyNum = $("#KeyNum").val();
    var NoteNum = $("#NoteNum").val();
    if ((KeyNum == "") || (!$.isNumeric(KeyNum)) || (KeyNum < 1)) {
        $("#e-obj").val("�ַ�������XML��JSONʱ����Ҫ������Ч�ֶ���ֵ(����)��");
        $("#KeyNum").focus();
        return false;
    }
    if (NoteNum != "") {
        if ((!$.isNumeric(NoteNum)) || (NoteNum < 1)) {
            $("#e-obj").val("˵������ҪΪ��Ч���֣�");
            $("#NoteNum").focus();
            return false;
        }
    }
    var Resolver = $('#Resolver').checkbox('getValue');
    var ObjStr = ""
    var LineArr = Str.split("\n");
    for (var line = 0; line < LineArr.length; line++) {
        var DataArr = LineArr[line].split("\t");
        var Key = DataArr[KeyNum - 1] || "";
        if (Key == "") continue;
        Key = Key.replace(/ /g, "");
        var Note = '';
        if (NoteNum != "") Note = DataArr[NoteNum - 1];
        PageLogicObj.m_ParseArr.push(["", "", Key, "", Note]);
        PageLogicObj.m_KeyArr.push({ "text": Key, "note": Note });
    }
    return true;
}
// ͨ�������ȡ�µ�˳�����
function GetSortObjByObj(Obj, Element) {
    var Element = Element || "";
    if (Array.isArray(Obj)) {
        //����ֻȡ��һ������
        PageLogicObj.m_ParseArr.push(["List", Element, "", ""]);
        GetSortObjByObj(Obj[0], Element);
        PageLogicObj.m_ParseArr.push(["ListEnd", Element, "", ""]);
    } else if (typeof Obj == "object") {
        //����ֻѭ����������
        var Arr = Object.getOwnPropertyNames(Obj);
        for (var i = 0; i < Arr.length; i++) {
            var Key = Arr[i];
            if (typeof Obj[Key] == "object") {
                var SNode = ChangeNode(Key);
                var EndObj = "List"
                if (!Array.isArray(Obj[Key])) {
                    PageLogicObj.m_ParseArr.push(["Obj", Key, "", ""]);
                    EndObj = "Obj"
                }
                GetSortObjByObj(Obj[Key], Key);
                PageLogicObj.m_ParseArr.push(["ObjEnd^" + EndObj, Element, Key, ""]);
            } else {
                var value = Obj[Key] || "";
                PageLogicObj.m_ParseArr.push(["", Element, Key, value]);
                PageLogicObj.m_KeyArr.push({ "text": Key, "note": "" });
            }
        }
    }
    return true;
}
/// ͨ��˳�������ȡm����д����
function GetMObjStr() {
    if (PageLogicObj.m_ParseArr.length == 0) return "";
    var ParentList = {};
    var Dynamic = $('#Dynamic').checkbox('getValue');
    var Resolver = $('#Resolver').checkbox('getValue');
    var KeyVal = $('#KeyVal').checkbox('getValue');
    var Root = Resolver ? "In" : "";
    var Str = GetDynamicObjStr(Root, "", Resolver);
    for (var i = 0; i < PageLogicObj.m_ParseArr.length; i++) {
        var OneObj = PageLogicObj.m_ParseArr[i];
        var ObjType = OneObj[0]; //�ڵ�����
        var PreObjType = "";
        if (ObjType.indexOf("^") > -1) {
            PreObjType = ObjType.split("^")[1];
            ObjType = ObjType.split("^")[0];
        }
        var ObjRoot = OneObj[1]; //�ϲ���ڵ�
        var ObjKey = OneObj[2]; //�ڵ�����
        var KeyVal = ObjKey.replace(/_/g, "");
        var ObjVal = OneObj[3]; //�ڵ�ֵ
        var ObjNote = OneObj[4] || ""; //�ڵ㱸ע
        ObjNote = (ObjNote == "") ? "" : ("					;" + ObjNote);
        var RootNode = ChangeNode(ObjRoot);
        var KeyNode = ChangeNode(ObjKey);
        if (!Resolver) {
            //����Json/Xml����
            if (ObjType != "") {
                if (ObjType == "Obj") {
                    Str = Str + GetDynamicObjStr(RootNode)
                }
                if (ObjType == "List") {
                    Str = Str + GetDynamicObjStr(RootNode, "Y")
                }
                if (ObjType == "ObjEnd") {
                    var EndNode = (ObjVal != "") ? "" : (KeyNode + PreObjType);
                    Str = Str + '\n' + 's ' + RootNode + 'Obj."' + ObjKey + '"=' + EndNode;
                }
                if (ObjType == "ListEnd") {
                    Str = Str + '\n' + 'd ' + RootNode + 'List.%Push(' + RootNode + 'Obj)';
                }
            } else if (ObjRoot != "") {
                if (!KeyVal) Str = Str + '\n' + 's ' + RootNode + 'Obj."' + ObjKey + '"=""' + ObjNote;
                if (KeyVal) Str = Str + '\n' + 's ' + RootNode + 'Obj."' + ObjKey + '"=' + KeyVal + ObjNote;
            } else {
                if (!KeyVal) Str = Str + '\n' + 's ' + Root + 'Obj."' + ObjKey + '"=""' + ObjNote;
                if (KeyVal) Str = Str + '\n' + 's ' + Root + 'Obj."' + ObjKey + '"=' + KeyVal + ObjNote;
            }
        } else {
            //����Json/Xml����
            if (ObjType != "") {
                if (ObjType == "Obj") {
                    Str = Str + '\n' + 's ' + RootNode + 'Obj=' + Root + 'Obj."' + ObjRoot + '"';
                }
                if (ObjType == "List") {
                    Str = Str + '\n' + 's Size=' + Root + 'Obj."' + ObjRoot + '".%Size()';
                    Str = Str + '\n' + 'for len=1:1:Size {';
                    Str = Str + '\n' + '	s ' + RootNode + 'Obj=' + Root + 'Obj."' + ObjRoot + '".%Get(len)';
                    ParentList[RootNode] = 1
                }
            } else if (ObjRoot != "") {
                if (ObjKey == "") continue;
                var ListFlag = ParentList[RootNode] || "";
                if (ListFlag != "") {
                    Str = Str + '\n' + '	s ' + KeyVal + '=' + RootNode + 'Obj."' + ObjKey + '"' + ObjNote;
                } else {
                    Str = Str + '\n' + 's ' + KeyVal + '=' + RootNode + 'Obj."' + ObjKey + '"' + ObjNote;
                }
            } else {
                Str = Str + '\n' + 's ' + KeyVal + '=' + Root + 'Obj."' + ObjKey + '"' + ObjNote;
            }
        }
    }
    if (!Resolver) {
        if (PageLogicObj.m_StrFlag == "JSON") {
            Str = Str + '\n' + 's JsonStream=' + Root + 'Obj.%ToJSON()';
        } else if (PageLogicObj.m_StrFlag == "XML") {
            Str = Str + '\n' + 's XMLStream=' + Root + 'Obj.%ToXML()';
        } else {
            Str = Str + '\n' + 's JsonStream=' + Root + 'Obj.%ToJSON()';
            Str = Str + '\n' + 's XMLStream=' + Root + 'Obj.%ToXML()';
        }
    }
    return Str;
}
// ��ȡm�ж����ʼ��д��
function GetDynamicObjStr(Node, ListFlag, Resolver) {
    var Str = "";
    var Node = Node || "";
    var ListFlag = ListFlag || "";
    var Resolver = Resolver || "";
    var Dynamic = $('#Dynamic').checkbox('getValue');
    if (Dynamic) {
        if (Resolver) {
            Str = Str + '\n' + 's ' + Node + 'Obj={}.%FromJSON(JsonStr)';
        } else {
            if (ListFlag == "Y") Str = Str + '\n' + 's ' + Node + 'List=[]';
            Str = Str + '\n' + 's ' + Node + 'Obj={}';
        }
    } else {
        if (Resolver) {
            if (PageLogicObj.m_StrFlag == "XML") Str = Str + '\n' + 's ' + Node + 'Obj=##class(DHCDoc.Util.FromXML).XML2Arr(XMLStr)';
            if (PageLogicObj.m_StrFlag == "JSON") Str = Str + '\n' + 's ' + Node + 'Obj=##class(DHCDoc.Util.FromXML).Json2Arr(JsonStr)';
        } else {
            if (ListFlag == "Y") Str = Str + '\n' + 's ' + Node + 'List=##class(DHCDoc.Util.ListData).%New()';
            Str = Str + '\n' + 's ' + Node + 'Obj=##class(DHCDoc.Util.ArrayData).%New()';
        }
    }
    return Str;
}
// ת���ڵ�����
function ChangeNode(FNode) {
    var RNode = "";
    if (FNode == "") return FNode;
    var NodeStr = $("#NodeStr").val();
    NodeStr = ReplaceStr(NodeStr);
    if (NodeStr != "") {
        var NodeArr = NodeStr.split(",");
        for (var index = 0; index < NodeArr.length; index++) {
            var NodeCode = NodeArr[index].split(":")[0];
            var ReplaceNode = NodeArr[index].split(":")[1];
            if (NodeCode == FNode) {
                RNode = ReplaceNode;
                break;
            }
        }
    }
    if (RNode != "") {
        FNode = RNode;
    } else {
        FNode = FNode.replace(/ |_/g, "");
        var Len = (FNode.length > 1) ? 2 : 1;
        FNode = FNode.substr(0, Len);
    }
    return FNode;
}
// ��ʽ����ѹ���ַ���
function FormaterClick() {
    try {
        $("#w-str").attr("wrap", "on");
        var Str = $("#w-str").val();
        Str = ReplaceStr(Str);
        var FirstStr = Str.substr(0, 1);
        if (("<{[").indexOf(FirstStr) == "-1") {
            $("#e-obj").val("�˲���ֻ���XML��JSON����");
            $("#w-str").focus();
            return false;
        }
        if (PageLogicObj.m_Compact == "Y") {
            //ѹ��
            var FormaterStr = Str;
        } else {
            //��ʽ��
            $("#w-str").attr("wrap", "off");
            if (FirstStr == "<") {
                //XML����
                var x2js = new X2JS();
                var Obj = x2js.xml_str2json(Str);
                PageLogicObj.m_StrFlag = "XML";
            } else {
                var Obj = JSON.parse(Str);
                PageLogicObj.m_StrFlag = "JSON";
            }
            var FormaterStr = FormaterObjStr(Obj);
            if (PageLogicObj.m_StrFlag == "JSON") {
                FormaterStr = "{" + FormaterStr + "\n}"
            }
        }
        $("#w-str").val(FormaterStr);
        PageLogicObj.m_StrFlag = "";
        PageLogicObj.m_Compact = (PageLogicObj.m_Compact != "Y") ? "Y" : "";
    } catch (e) {
        $("#e-obj").val(e.message);
        console.log(e);
    }
}
// ��ʽ������
function FormaterObjStr(Obj, Space) {
    var Str = "";
    var Space = Space || "	";
    //����ֻѭ����������
    var Arr = Object.getOwnPropertyNames(Obj);
    for (var i = 0; i < Arr.length; i++) {
        var Key = Arr[i];
        var Val = Obj[Key];
        var SubStrF = '<' + Key + '>';
        var SubStrL = '</' + Key + '>';
        var Symbol = "";
        if (PageLogicObj.m_StrFlag == "JSON") {
            SubStrF = '"' + Key + '":';
            SubStrL = '}';
            Symbol = ((i + 1) != Arr.length) ? "," : "";
        }
        if (typeof Val == "object") {
            if (PageLogicObj.m_StrFlag == "JSON") {
                if (Array.isArray(Val)) {
                    SubStrF = SubStrF + '[';
                    SubStrL = ']' + Symbol;
                } else {
                    SubStrF = SubStrF + '{';
                    SubStrL = '}' + Symbol;
                }
            }
            var SubSpace = Space + "	";
            Str = Str + '\n' + Space + SubStrF;
            if (Array.isArray(Val)) {
                for (var len = 0; len < Val.length; len++) {
                    var ArrStr = FormaterObjStr(Val[len], SubSpace + "	");
                    if (PageLogicObj.m_StrFlag == "JSON") {
                        Symbol = ((len + 1) != Val.length) ? "," : "";
                    }
                    Str = Str + "\n" + SubSpace + "{" + ArrStr + "\n" + SubSpace + "}" + Symbol;
                }
            } else {
                var SubStr = FormaterObjStr(Val, SubSpace);
                Str = Str + SubStr;
            }
            Str = Str + '\n' + Space + SubStrL;
        } else {
            if (PageLogicObj.m_StrFlag == "XML") {
                Str = Str + '\n' + Space + SubStrF + Val + SubStrL;
            } else {
                Str = Str + '\n' + Space + SubStrF + '"' + Val + '"' + Symbol;
            }
        }
    }
    return Str
}
// ȥ���ַ����еĻ��з��Ϳո�(��ֹ���ƺ��ֶ����пո�)
function ReplaceStr(Str) {
    var Str = Str.trimLeft().trimRight();
    var FirstStr = Str.substr(0, 1);
    if (("<{[").indexOf(FirstStr) > -1) {
        Str = Str.replace(/[\r\n\t\ +]/g, "");
    }
    Str = Str.replace(/��|��/g, ",");
    return Str
}
// �ı䰴ť��ʽ
function ChangeButtonText(element, icon, desc) {
    $(element).linkbutton({
        iconCls: icon,
        plain: true,
        //text: ""
    });
    $(element).popover({
        content: desc,
        trigger: 'hover'
    });
}
// ��ʼ����ʾ��Ϣ
function InitTip() {
    var _content = "<ul class='tip_class'><li style='font-weight:bold'>ʹ��˵��</li>" +
        "<li>1���ϲ�Ϊ����������(��ͬ���ö�Ӧ��ͬ���Ч��)�����Ϊ����ʽ�������ݣ��Ҳ�Ϊm�е�д���������</li>" +
        "<li>2��Ĭ�ϵĹ�������Ϊ����̬д������֯xml��json������Ҫ��Ϊ��̬д�������д�����빴�϶�Ӧ����</li>" +
        "<li>3���ڵ㶨���ʽ�� AB:A,AC:C...����AB�ڵ��滻ΪA��AC�ڵ��滻ΪC����Ҫ������ڵ�����</li>" +
        "<li>4��������ݿ�ΪXML��JSON���ĵ��е��ֶ�˵��������Ӧ�İ�ť�У�תM�ַ�����תM���󡢸�ʽ��/ѹ����</li>" +
        "<li>5������ȡֵ����ѡ���Ӧ���ֶ�ȡֵд��,˫���������ɶ��ֶ������б༭(�����������תM�������,���ֶ�����ѡ��),</li>" +
        "<li><span>  ���ȷ�ϻ�����ݼ��ص������档</span></li>"
    return _content;
}

function BodykeydownHandler(e) {
    if (window.event) {
        var keyCode = window.event.keyCode;
        var type = window.event.type;
        var SrcObj = window.event.srcElement;
    } else {
        var keyCode = e.which;
        var type = e.type;
        var SrcObj = e.target;
    }
    //�������Backspace������  
    var keyEvent;
    if (e.keyCode == 8) {
        var d = e.srcElement || e.target;
        if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
            keyEvent = d.readOnly || d.disabled;
        } else {
            keyEvent = true;
        }
    } else {
        keyEvent = false;
    }
    if (keyEvent) {
        e.preventDefault();
    }
    //�س��¼�����
    if (keyCode == 13) {
        if ((SrcObj.tagName == "A") || (SrcObj.tagName == "INPUT")) {
            if ((SrcObj.id == "TabRowID")) {
                LoadTreeDataGrid();
                return false;
            }
            return true;
        }
    }
}

function ShowGetTabData() {
    $("#PackName").val("User");
    InitTreeDataGrid();
    $("#win-TabData").window('open');
    return

    var URL = "dhcdoc.gettabdata.csp";
    websys_showModal({
        url: URL,
        title: '��ȡ������',
        width: 1000,
        height: 700,
        KeyArr: PageLogicObj.m_KeyArr,
        CallBackFunc: function(result) {
            if (result == "") {
                return "";
            }
        }
    })
}

function InitTabNameCombobox() {
    $("#TabName").combobox({
        valueField: 'id',
        textField: 'text',
        mode: 'remote',
        onShowPanel: function() {
            // ֻ������������ʾʱ,��ȥ����url��ȡ����,��������ٶ�
            var url = $(this).combobox('options').url;
            if (!url) {
                var url = $URL + "?ClassName=DHCDoc.Util.cmd&MethodName=GetTabNameList&ResultSetType=array";
                $(this).combobox('reload', url);
            }
        },
        onBeforeLoad: function(param) {
            var packageName = $("#PackName").val();
            param.className = "DHC-APP";
            param.packageName = packageName;
            param.className = param.q;
        },
        onSelect: function(rec) {
            LoadTreeDataGrid();
        }
    });
}

function InitTreeDataGrid() {
    var KeyArr = PageLogicObj.m_KeyArr;
    var EditorTree = {
        type: 'combobox',
        options: {
            valueField: 'text',
            textField: 'text',
            data: KeyArr
        }
    }
    var EditorText = { type: 'text' };
    var NameEdit = (KeyArr.length > 0) ? EditorTree : EditorText;
    $('#TreeTabData').treegrid({
        toolbar: [],
        idField: 'id',
        treeField: 'code',
        checkbox: true,
        border: false,
        rownumbers: true,
        animate: true,
        collapsible: true,
        fitColumns: true,
        columns: [
            [
                { title: '�ֶ�', field: 'code', width: 300, align: 'left' },
                //{ title: '����', field: 'type', width: 150, align: 'center' },
                { title: '���ʽ', field: 'expression', width: 500, align: 'left' },
                { title: '����(<span style="color:red">˫���ɱ༭</span>)', field: 'name', width: 300, align: 'left', editor: NameEdit },
                { title: '˵��', field: 'description', width: 300, align: 'left' }
            ]
        ],
        onDblClickRow: function(index, row) {
            if (index.indexOf("Master") > -1) return;
            $('#TreeTabData').treegrid('beginEdit', index);
        },
        onClickCell: function(field, row) {
            if (field != "code") { $('#TreeTabData').treegrid('checkNode', row.id); }
        }
    });
}

function LoadTreeDataGrid() {
    var nameSpace = "DHC-APP";
    var packageName = $("#PackName").val();
    var className = $("#TabName").combobox("getValue");
    if (packageName == "") {
        $.messager.alert('��ʾ', "���������!", "info", function() {
            $('#PackName').focus();
        });
    }
    if (className == "") {
        $.messager.alert('��ʾ', "���������!", "info", function() {
            $('#TabName').focus();
        });
    }
    var RowID = $("#TabRowID").val();
    $.cm({
        ClassName: "DHCDoc.Util.cmd",
        MethodName: "GetTableInfoJSON",
        nameSpace: nameSpace,
        packageName: packageName,
        className: className,
        rowid: RowID,
        rows: 200
    }, function(GridData) {
        $('#TreeTabData').treegrid('loadData', GridData);
    });
}

function SaveTabData() {
    var Str = ProStr = NodeStr = DynamicStr = "";
    var CuStr = $("#e-obj").val();
    var SQLFlag = $('#SQLFlag').checkbox('getValue');
    var DynamicSQL = $('#DynamicSQL').checkbox('getValue');
    var Arr = $('#TreeTabData').treegrid('getCheckedNodes');
    for (var i = 0; i < Arr.length; i++) {
        var id = Arr[i].id;
        var code = Arr[i].code;
        var name = "";
        var editors = $('#TreeTabData').treegrid('getEditors', id)[0];
        if (editors && editors.target) {
            var targetType = editors.type;
            if (targetType == "combobox") {
                name = editors.target.combobox('getText');
            } else {
                name = editors.target.val();
            }
        }
        name = name || code;
        var Alias = name.replace(/_| /g, "");
        var propertycode = Arr[i].propertycode;
        var expression = Arr[i].expression;
        if ((SQLFlag || DynamicSQL) && (propertycode != "")) {
            if (SQLFlag) {
                ProStr = (ProStr == "") ? propertycode : (ProStr + "," + propertycode);
                NodeStr = (NodeStr == "") ? (":" + Alias) : (NodeStr + ",:" + Alias);
            }
            if (DynamicSQL) {
                DynamicStr = (DynamicStr == "") ? (propertycode + " AS " + Alias) : (DynamicStr + "," + propertycode + " AS " + Alias);
            }
        } else {
            Str += "s " + Alias + "=" + expression + "\n";
        }
    }
    if ((ProStr != "") || (DynamicStr != "")) {
        //SQLȡֵ��
        var PackName = $("#PackName").val();
        var ClassName = $("#TabName").combobox("getValue");
        var TableArr = tkMakeServerCall("DHCDoc.Util.cmd", "GetTabName", PackName, ClassName).split("^");
        if (TableArr[0] != "0") { Str = TableArr[1]; } else {
            var TableName = TableArr[1];
            if (ProStr != "") {
                Str = "&SQL(SELECT " + ProStr + "\n" + " INTO " + NodeStr + "\n" + " FROM " + TableName + " WHERE %ID=:rowid)";
                Str += "\n" + "if SQLCODE {" + "\n" + "	Q SQLCODE_\"^\"_$g(%msg)" + "\n" + "}";
            }
            if (DynamicStr != "") {
                SQlStr = "SELECT " + DynamicStr + " FROM " + TableName + " WHERE %ID=?";
                Str = 's SQLStr="' + SQlStr + '"';
                Str += "\n" + "s result=##class(DHCDoc.Util.DynamicSql).GetQueryObjBySqlStr(SQLStr,RowID)";
                Str += "\n" + "if $IsObject(result){";
                Str += "\n" + "	While result.Next(.sc) {";
                Str += "\n" + "		Write result.Get(\"PAADM_RowID\"),!";
                Str += "\n" + "	}";
                Str += "\n" + "}else{";
                Str += "\n" + "	write result ,!";
                Str += "\n" + "}";
            }
        }
    }
    $("#win-TabData").window('close');
    $("#e-obj").attr("wrap", "off");
    $("#e-obj").val("\n" + Str + "\n" + CuStr);
}
