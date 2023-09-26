document.body.onload = BodyLoadHandler;
var SelectedRow=0
function BodyLoadHandler(){
    //alert(1)
    var AddBtnObj = document.getElementById("AddBtn");  
    if(AddBtnObj){AddBtnObj.onclick = Save_Click;}
    var UpdateBtnObj = document.getElementById("UpdateBtn");
    if(UpdateBtnObj){UpdateBtnObj.onclick = Update_Click;}
    var DeleteBtnObj = document.getElementById("DeleteBtn");
    if(DeleteBtnObj){DeleteBtnObj.onclick = Delete_Click;}
}

function Save_Click(){
    var Code,Desc,ActiveFlag,Note
    var Rowid = document.getElementById("Rowid").value
    var CodeObj = document.getElementById("Code");
    if(CodeObj){Code = CodeObj.value}
    var DescObj = document.getElementById("Desc");
    if(DescObj){Desc = DescObj.value}
    var ActiveFlagObj = document.getElementById("ActiveFlag");
    if(ActiveFlagObj){ActiveFlag = ActiveFlagObj.checked;}
    var NoteObj = document.getElementById("Text");
    if(NoteObj){Note = NoteObj.value;}
    if(Code==""){
        alert("���벻��Ϊ��!");
        CodeObj.onfocus;
        return;
    }
    if(Desc==""){
        alert("��������Ϊ��!");
        DescObj.onfocus;
        return;
    }
    var SaveMethodObj = document.getElementById("SaveEnc");
    if(SaveMethodObj){var encmeth = SaveMethodObj.value;}else{var encmeth="";} 
    if(encmeth!=""){
        var Para=Rowid+"^"+Code+"^"+Desc+"^"+ActiveFlag+"^"+Note
        var ret=cspRunServerMethod(encmeth,Para);
        if(ret==-99){
        	alert("�����ظ���������ά��")
        	return;
        }else if(ret!=-1){
            alert("����ɹ�!");
            location.reload();
        }else{
            alert("����ʧ��!");
            return;
        }
    }
}

function Update_Click(){
    var Code,Desc,ActiveFlag,Note
    var Rowid = document.getElementById("Rowid").value;
    if(Rowid==""){alert("��ѡ��Ҫ���µ�����!");return;}
    var CodeObj = document.getElementById("Code");
    if(CodeObj){Code = CodeObj.value}
    var DescObj = document.getElementById("Desc");
    if(DescObj){Desc = DescObj.value}
    var ActiveFlagObj = document.getElementById("ActiveFlag");
    if(ActiveFlagObj){ActiveFlag = ActiveFlagObj.checked;}
    var NoteObj = document.getElementById("Text");
    if(NoteObj){Note = NoteObj.value;}
    if(Code==""){
        alert("���벻��Ϊ��!");
        return;
    }
    if(Desc==""){
        alert("��������Ϊ��!");
        return;
    }
    var UpdateMethodObj = document.getElementById("UpdateEnc");
    if(UpdateMethodObj){var encmeth = UpdateMethodObj.value;}else{var encmeth="";} 
    if(encmeth!=""){
        var Para=Rowid+"^"+Code+"^"+Desc+"^"+ActiveFlag+"^"+Note
        var ret=cspRunServerMethod(encmeth,Para);
        if(ret!=-1){
            alert("���³ɹ�!");
            location.reload();
        }else{
            alert("����ʧ��!");
        }
    }
}

function Delete_Click(){
    var Rowid=document.getElementById("Rowid").value;
    if(Rowid==""){
    	alert("��ѡ������ɾ����¼��")
    	return;
    	}
    var DeleteObj = document.getElementById("DeleteEnc");
    if(DeleteObj){var encmeth = DeleteObj.value;}else{var encmeth="";} 
    if(encmeth!=""){
        var ret=cspRunServerMethod(encmeth,Rowid);
        if(ret==1){
            alert("ɾ���ɹ�!");
            location.reload();
        }else{
            alert("ɾ��ʧ��!");
        }
    }
}

function SelectRowHandler(){
    var eSrc=window.event.srcElement;
    var objtbl=document.getElementById('tDHCAntCombinedUseReason');
    var rows=objtbl.rows.length;
    var lastrowindex=rows - 1;
    var rowObj=getRow(eSrc);
    var selectrow=rowObj.rowIndex;
    if (!selectrow) return;
    var RowidObj = document.getElementById("Rowid");
    var CodeObj = document.getElementById("Code");
    var DescObj = document.getElementById("Desc");
    var ActiveFlagObj = document.getElementById("ActiveFlag");
    var NoteObj = document.getElementById("Text");
    if (selectrow!=SelectedRow){
                
        var TCode = document.getElementById("TCodez"+selectrow);
        var TDesc = document.getElementById("TDescz"+selectrow);
        var TActiveFlag = document.getElementById("TActiveFlagz"+selectrow);
        var TText = document.getElementById("TTextz"+selectrow);
        var TRowid = document.getElementById("TRowidz"+selectrow);
        RowidObj.value = TRowid.value;
        CodeObj.value = TCode.innerText;
        DescObj.value = TDesc.innerText;
        if(TActiveFlag.innerText=="��"){
            ActiveFlagObj.checked = true;  
        }else{
            ActiveFlagObj.checked = false;
        }
        NoteObj.value = TText.innerText;
        SelectedRow=selectrow;
        return;
    }else{
        SelectedRow=0;
        RowidObj.value = "";
        CodeObj.value = "";
        DescObj.value = "";
        ActiveFlagObj.checked = false;
        NoteObj.value = "";
    }
}