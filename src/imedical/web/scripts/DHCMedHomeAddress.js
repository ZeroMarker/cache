function cmdConfirm_OnClick()
{
	var Province="",City="",Prefecture="",Town="",Village="",Doorplate="";
	var Address="",Err="";
	var obj=document.getElementById("Province");
	if (obj){Province=obj.value;}
	var obj=document.getElementById("City");
	if (obj){City=obj.value;}
	var obj=document.getElementById("Prefecture");
	if (obj){Prefecture=obj.value;}
	var obj=document.getElementById("Town");
	if (obj){Town=obj.value;}
	var obj=document.getElementById("Village");
	if (obj){Village=obj.value;}
	var obj=document.getElementById("Doorplate");
	if (obj){Doorplate=obj.value;}
	
	if (Province!==""){
		Address=Province+" ";
	}else{
		Err=Err+t['Province1'];
	}
	if ((Province!==City)&&(City!=="")){
		Address=Address+City+" ";
	}else if(City==""){
		Err=t['City1'];
	}
	if (Prefecture!==""){
		Address=Address+Prefecture+" ";
	}else{
		Err=Err+t['Prefecture1'];
	}
	if (Town!==""){
		Address=Address+Town+" ";
	}else{
		Err=Err+t['Town1'];
	}
	if (Village!==""){
		Address=Address+Village+" ";
	}else{
		Err=Err+t['Village1'];
	}
	if (Doorplate!==""){
		Address=Address+Doorplate+"";
	}else{
		Err=Err+t['Doorplate1'];
	}
	
	if (Err!==""){
		alert(Err);
		return;
	}
	
	window.returnValue = Address;
	window.close();
}

function Province_onchange()
{
	alert("Province_onchange");
}

function initForm()
{
	var obj=document.getElementById("cmdConfirm");
	if (obj){obj.onclick=cmdConfirm_OnClick;}
}

initForm();

function LookUpProvice(str)
{
	var obj=document.getElementById('Province');
	var objID=document.getElementById('ProvinceID');
	var tem=str.split("^");
	obj.value=tem[2];
	objID.value=tem[0];
}
function LookUpCity(str)
{
	var obj=document.getElementById('City');
	var objID=document.getElementById('CityID');
	var tem=str.split("^");
	obj.value=tem[2];
	objID.value=tem[0];
}
function LookUpPrefecture(str)
{
	var obj=document.getElementById('Prefecture');
	var objID=document.getElementById('PrefectureID');
	var tem=str.split("^");
	obj.value=tem[2];
	objID.value=tem[0];
}
function LookUpTown(str)
{
	var obj=document.getElementById('Town');
	var objID=document.getElementById('TownID');
	var tem=str.split("^");
	obj.value=tem[2];
	objID.value=tem[0];
}

function LookUpVillage(str)
{
	var obj=document.getElementById('Village');
	var objID=document.getElementById('VillageID');
	var tem=str.split("^");
	obj.value=tem[2];
	objID.value=tem[0];
}