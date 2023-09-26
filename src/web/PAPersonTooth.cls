Class web.PAPersonTooth Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 652;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TOOTH_RowId";

Parameter SQLDESCRIPTION = "TOOTH_RowId";

Parameter SQLROWID = "TOOTH_RowId";

Property dummy As %String(TRUNCATE = 1);

Query FindOrdTreatments(patID As %String, posId As %String, numId As %String, site As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "DENSTDesc")
{
	SELECT HIST_OEOrdItem_DR->OEORI_ItmMast_DR->ARCIM_DentalState_DR->DENST_Desc
 	FROM SQLUser.PA_PersonToothHistory
 	WHERE HIST_ParRef->TOOTH_ParRef=:patID AND HIST_ParRef->TOOTH_Position_DR=:posId AND HIST_ParRef->TOOTH_Number_DR=:numId
 	AND HIST_OEOrdItem_DR->OEORI_ItemStat_DR->OSTAT_Code='E'
 	AND HIST_ToothArea_DR->TOOTHA_Code=:site
}

Query FindNonOrdTreatments(patID As %String, posId As %String, numId As %String, site As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "DENSTDesc")
{
	SELECT HIST_DentalState_DR->DENST_Desc
 	FROM SQLUser.PA_PersonToothHistory
 	WHERE HIST_ParRef->TOOTH_ParRef=:patID AND HIST_ParRef->TOOTH_Position_DR=:posId AND HIST_ParRef->TOOTH_Number_DR=:numId
 	AND HIST_OEOrdItem_DR IS NULL
 	AND HIST_ToothArea_DR->TOOTHA_Code=:site
}

Query FindPatToothIdByPosNum(patID As %String, posId As %String, numId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "TOOTHId")
{
	SELECT TOOTH_RowId
 	FROM SQLUser.PA_PersonTooth
 	WHERE TOOTH_ParRef=:patID
 	AND TOOTH_Position_DR->TOOTHP_Code = :posId
 	AND TOOTH_Number_DR->TOOTHN_Code = :numId
 	and (TOOTH_Active = 'Y' or TOOTH_Active is null)
}

ClassMethod GetToothComments(patId As %String, pos As %String, num As %String) As %Library.String
{
}

ClassMethod GetTeeth(Teeth, TeethRef, HiddenState, HiddenTreat, HiddenColour, HiddenID, HiddenPos, HiddenNum, HiddenArea, HiddenImage, HiddenHist)
{
}

/// YC - Checks to see if there are any active teeth. Returns 1 or 0.
ClassMethod ActiveTeethExist(PatientID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetPatientTeeth(Teeth, TeethRef, HiddenState, HiddenTreat, HiddenColour, HiddenID, HiddenPos, HiddenNum, HiddenArea, HiddenImage, HiddenHist)
{
}

ClassMethod AddDataToHidden(ToothPosn, ToothNumber, data, HiddenState, HiddenTreat, HiddenColour, HiddenID, HiddenPos, HiddenNum, HiddenArea, HiddenImage, HiddenHist)
{
}

ClassMethod ShowOdontoGram()
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String = "", id As %String = "")
{
}

/// This saves the component PAPersonToothComments.Edit
ClassMethod websysSaveComments(compref As %String = "", id As %String = "")
{
}

/*
ClassMethod GetTooth(ToothPosn, ToothNumber)
{
 ; returns:
 ; $li:
 ;  1: toothtype
 ;  2: tooth data 
 ;   	diag, 
 ;   	treatment
 ;   	colour
 ;  3: root data
 ;   	diag, 
 ;   	treatment
 ;   	colour
 ;  4: face data:
 ;   	diag, 
 ;   	treatment
 ;   	colour
 ;  
 ;n (ToothPosn,ToothNumber) 

 s data=$g(^zPhilTeeth(ToothPosn,ToothNumber))
 i (ToothPosn="")!(ToothNumber="")!(data="") q $lb("","","","")

 s HiddenID=HiddenID_ToothPosn_ToothNumber_"Number"_$c(1)
 s HiddenDiag=HiddenDiag_$c(1)
 s HiddenTreat=HiddenTreat_$c(1)
 s HiddenColour=HiddenColour_"White"_$c(1)

 s type=$lg(data,1)
 s tooth=$lg(data,2)
 s HiddenID=HiddenID_ToothPosn_ToothNumber_"Tooth"_$c(1)
 s HiddenDiag=HiddenDiag_$lg(tooth,1)_$c(1)
 s HiddenTreat=HiddenTreat_$lg(tooth,2)_$c(1)
 s HiddenColour=HiddenColour_$lg(tooth,3)_$c(1)

 s root=$lg(data,3)
 s HiddenID=HiddenID_ToothPosn_ToothNumber_"Root"_$c(1)
 s HiddenDiag=HiddenDiag_$lg(root,1)_$c(1)
 s HiddenTreat=HiddenTreat_$lg(root,2)_$c(1)
 s HiddenColour=HiddenColour_$lg(root,3)_$c(1)

 s allfaces=$lg(data,4)
 f x=1:1:5 d 
 . s theface=$lg(allfaces,x)
 . s HiddenID=HiddenID_ToothPosn_ToothNumber_"Face"_x_$c(1)
 . s HiddenDiag=HiddenDiag_$lg(theface,1)_$c(1)
 . s HiddenTreat=HiddenTreat_$lg(theface,2)_$c(1)
 . s HiddenColour=HiddenColour_$lg(theface,3)_$c(1)
 . s $li(faces,x)=theface
 
 q $lb(type,tooth,root,faces)
 ; tooth
 ; root
 ; faces
}

ClassMethod ShowOdontoGram()
{
 ;n (%request,%session,msg)
 
 s CrLf=$c(13,10)
 s (width,height)=28
 s imagedir="../images/webemr/Dental/"
 
 ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 ;s ColNone="#FFFFFF"
 ;s ColDead="#000000"
 ;s ColFill="#00FFFF"
 ;s ColPlan="#A0B0CF"
 s ColNone="White"
 s ColDead="Black"
 s ColFill="#C0C0C0"
 s ColPlan="#00FFFF"
 s none=$lb("","",ColNone)
 s dead=$lb("dead","remove",ColDead)
 s crown=$lb("crown","Crown planned",ColPlan)
 s fill=$lb("carie","fill",ColFill)
 s crown2=$lb("carie","Crown planned",ColPlan)
 s facefill=$lb("carie","fill",ColFill)
 s FacesGood=$lb(none, none, none, none, none)
 s FacesBad=$lb(facefill, none, none, facefill, facefill)
 s ^zPhilTeeth("UL","8")=$lb(2,crown,dead,FacesBad)
 s ^zPhilTeeth("UL","7")=$lb(0,"","","")
 s ^zPhilTeeth("UL","6")=$lb(2,crown,none,FacesGood)
 s ^zPhilTeeth("UL","5")=$lb(1,none,none,FacesGood)
 s ^zPhilTeeth("UL","4")=$lb(1,none,none,FacesGood)
 s ^zPhilTeeth("UL","3")=$lb(3,none,none,FacesGood)
 s ^zPhilTeeth("UL","2")=$lb(4,none,fill,FacesBad)
 s ^zPhilTeeth("UL","1")=$lb(4,none,none,FacesBad)
 
 s ^zPhilTeeth("UR","1")=$lb(4,none,none,FacesBad)
 s ^zPhilTeeth("UR","2")=$lb(4,none,fill,FacesBad)
 s ^zPhilTeeth("UR","3")=$lb(3,none,none,FacesGood)
 s ^zPhilTeeth("UR","4")=$lb(1,none,none,FacesGood)
 s ^zPhilTeeth("UR","5")=$lb(1,none,none,FacesGood)
 s ^zPhilTeeth("UR","6")=$lb(2,crown,none,FacesGood)
 s ^zPhilTeeth("UR","7")=$lb(0,"","","")
 s ^zPhilTeeth("UR","8")=$lb(2,dead,dead,FacesGood)
 
 s ^zPhilTeeth("LL","8")=$lb(2,dead,dead,FacesGood)
 s ^zPhilTeeth("LL","7")=$lb(0,"","","")
 s ^zPhilTeeth("LL","6")=$lb(2,crown,none,FacesGood)
 s ^zPhilTeeth("LL","5")=$lb(1,none,none,FacesGood)
 s ^zPhilTeeth("LL","4")=$lb(1,none,none,FacesGood)
 s ^zPhilTeeth("LL","3")=$lb(3,none,none,FacesGood)
 s ^zPhilTeeth("LL","2")=$lb(4,none,fill,FacesBad)
 s ^zPhilTeeth("LL","1")=$lb(4,none,none,FacesBad)

 s ^zPhilTeeth("LR","1")=$lb(4,none,none,FacesBad)
 s ^zPhilTeeth("LR","2")=$lb(4,none,fill,FacesBad)
 s ^zPhilTeeth("LR","3")=$lb(3,none,none,FacesGood)
 s ^zPhilTeeth("LR","4")=$lb(1,none,none,FacesGood)
 s ^zPhilTeeth("LR","5")=$lb(1,none,none,FacesGood)
 s ^zPhilTeeth("LR","6")=$lb(2,crown,none,FacesGood)
 s ^zPhilTeeth("LR","7")=$lb(0,"","","")
 s ^zPhilTeeth("LR","8")=$lb(2,dead,dead,FacesGood)
 ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 s ToothPosn=""
 ; GetTeeth
 k TeethRef
 ; hidden fields to hold treatment/diagnosis
 s (HiddenDiag, HiddenTreat,HiddenColour,HiddenID)=""
 f  s ToothPosn=$o(^OEC("TOOTHP",0,"Code",ToothPosn)) q:ToothPosn=""  d
 . s ToothNumber=""
 . f  s ToothNumber=$o(^OEC("TOOTHN",0,"Code",ToothNumber)) q:ToothNumber=""  d
 . . s TeethRef(ToothPosn,ToothNumber)=..GetTooth(ToothPosn,ToothNumber)
 
 w "<INPUT type=HIDDEN name='HiddenID' ID='HiddenID' value='"_HiddenID_"'>",CrLf
 w "<INPUT type=HIDDEN name='HiddenDiag' ID='HiddenDiag' value='"_HiddenDiag_"'>",CrLf
 w "<INPUT type=HIDDEN name='HiddenTreat' ID='HiddenTreat' value='"_HiddenTreat_"'>",CrLf
 w "<INPUT type=HIDDEN name='HiddenColour' ID='HiddenColour' value='"_HiddenColour_"'>",CrLf
  
 k ToothTypes
 s ToothTypes(0)="Extract",FaceTypes(0)=""
 s ToothTypes(1)="Mol1",FaceTypes(1)="4"
 s ToothTypes(2)="Mol2",FaceTypes(2)="5"
 s ToothTypes(3)="Can1",FaceTypes(3)="4"
 s ToothTypes(4)="Inc1",FaceTypes(4)="4"
 
 s DataID=0
 w "<TABLE id ='tPAAdm_Dental_Odontogram'  cellspacing=12 cellpadding=0 bgColor=white>",CrLf
 ; Upper Face
 d DoRow("U","Face",.TeethRef)
 ; Upper Root
 ;d DoRow("U","Root",.TeethRef)
 ; Upper Teeth
 d DoRow("U","Tooth",.TeethRef)
 ; Upper Numbers
 d DoRow("U","Number",.TeethRef)

 ; Lower Numbers
 d DoRow("L","Number",.TeethRef)
 ; Lower Teeth
 d DoRow("L","Tooth",.TeethRef)
 ; Lower Root
 ;d DoRow("L","Root",.TeethRef)
 ; Lower Face
 d DoRow("L","Face",.TeethRef)


 w "</TABLE>",$c(13,10)
 q	

DoRow(pos,type,TeethRef)
 ; pos = 'U', 'L'
 ; type = 'Face', 'Root', 'Tooth', 'Number'
 w "<TR>",CrLf
 ;w "<TD><LABEL>"_pos_": "_type_"</LABEL></TD>",CrLf
 ; do left C, B, A, 8..1, 
 ; then right 1..8, A, B, C
 f side="L","R" d
 . i side="R" s direction=1
 . e  s direction="-1"
 . s tx="" f  s tx=$o(TeethRef(pos_side,tx),direction) q:tx=""  d
 . . s toothdata=TeethRef(pos_side,tx)
 . . s toothtype=$lg(toothdata,1)
 . . ; if tooth not present..
 . . i toothtype="" w "<TD></TD>",CrLf q
 . . w "<TD><TABLE border=0 cellspacing=0 cellpadding=0 bgcolor=white>"
 . . i type="Face" s faces=FaceTypes(toothtype) d Face($lg(toothdata,4),faces)
 . . i type="Tooth" d Tooth($lg(toothdata,2),$lg(toothdata,3))
 . . ;i type="Root" d Tooth($lg(toothdata,3))
 . . i type="Number" d Number()
 . .  w "</TABLE></TD>",CrLf
 w "</TR>",CrLf ; Faces Row
 q
Face(facedata, faces)
 
 ; write another table..
 i faces=5 d
 . s bgcolor=$lg($lg(facedata,1),3)
 . w "<TR><TD id='"_$$TDid(1, type)_"' width='28' height='8' colspan=3 bgcolor='"_bgcolor_"' align='center' valign='bottom'>"
 . w $$Image(imagedir_"Dent5FT.gif", 1, type)_"</TR>"
 . s bgcolor=$lg($lg(facedata,2),3)
 . w "<TR><TD id='"_$$TDid(2, type)_"' width='9' height='12' bgcolor='"_bgcolor_"' align='right'>"
 . w $$Image(imagedir_"Dent5FL.gif", 2, type)
 . s bgcolor=$lg($lg(facedata,3),3)
 . w "<TD id='"_$$TDid(3, type)_"' width='10' height='12' bgcolor='"_bgcolor_"' align='center'>"
 . w $$Image(imagedir_"Dent5FC.gif", 3, type)
 . s bgcolor=$lg($lg(facedata,4),3)
 . w "<TD id='"_$$TDid(4, type)_"' width='9' height='12' bgcolor='"_bgcolor_"' align='left'>"
 . w $$Image(imagedir_"Dent5FR.gif", 4, type)
 . s bgcolor=$lg($lg(facedata,5),3)
 . w "<TR><TD id='"_$$TDid(5, type)_"' width='28' height='8' colspan=3 bgcolor='"_bgcolor_"' align='center' valign='top'>"
 . w $$Image(imagedir_"Dent5FB.gif", 5, type)_"</TR>",CrLf
 i faces=4 d
 . s bgcolor=$lg($lg(facedata,1),3)
 . w "<TR><TD id='"_$$TDid(1, type)_"' width='28' height='8' colspan=2 bgcolor='"_bgcolor_"' align='center' valign='bottom'>"
 . w $$Image(imagedir_"Dent4FT.gif", 1, type)_"</TR>",CrLf
 . s bgcolor=$lg($lg(facedata,2),3)
 . w "<TR><TD id='"_$$TDid(2, type)_"' width='14' height='12' bgcolor='"_bgcolor_"' align='right'>"
 . w $$Image(imagedir_"Dent4FL.gif", 2, type)
 . s bgcolor=$lg($lg(facedata,3),3)
 . w "<TD id='"_$$TDid(3, type)_"' width='14' height='12' bgcolor='"_bgcolor_"' align='left'>"
 . w $$Image(imagedir_"Dent4FR.gif", 3, type)_"</TR>",CrLf
 . s bgcolor=$lg($lg(facedata,4),3)
 . w "<TR><TD id='"_$$TDid(4, type)_"' width='28' height='8' colspan=2 bgcolor='"_bgcolor_"' align='center' valign='top'>"
 . w $$Image(imagedir_"Dent4FB.gif", 4, type)_"</TR>",CrLf
 q
Number()
 ; write another table..
 ; bordercolorlight="#C0C0C0" bordercolordark="#808080"
 w "<TR><TD><TABLE border=1 >"
 w "<TR><TD id='"_$$TDid("", type)_"' onclick='"_$$clickstr("", "Number")_"' valign='"_$s(pos="U":"top",1:"bottom")_"'  align='center' >"_pos_side,tx,CrLf_"</TD></TR>"
 w "</TD></TR></TABLE></TD></TR>"
 q
Tooth(toothdata,rootdata)
 s gif=ToothTypes(toothtype)
 ; make a string like: DentLMol2.gif
 s bgcolor=$lg(toothdata,3) 
 s rtbgcolor=$lg(rootdata,3) 
 s rtgif=imagedir_"Dent"_pos_gif_"Rt"_".gif"
 s gif=imagedir_"Dent"_pos_gif_".gif"
 i pos="U" d
 . w "<TR><TD id='"_$$TDid("", "Root")_"' valign='bottom' bgcolor='"_rtbgcolor_"' align='center' width='"_width_"' height='"_height_"'>",CrLf
 . w $$Image(rtgif, "", "Root")_"</TR>"
 . w "<TR><TD id='"_$$TDid("", "Tooth")_"' valign='top' bgcolor='"_bgcolor_"' align='center' width='"_width_"' height='"_height_"'>",CrLf
 . w $$Image(gif, "", "Tooth")_"</TR>"
 e  d
 . w "<TR><TD id='"_$$TDid("", "Tooth")_"' valign='bottom' bgcolor='"_bgcolor_"' align='center' width='"_width_"' height='"_height_"'>",CrLf
 . w $$Image(gif, "", "Tooth")_"</TR>"
 . w "<TR><TD id='"_$$TDid("", "Root")_"' valign='top' bgcolor='"_rtbgcolor_"' align='center' width='"_width_"' height='"_height_"'>",CrLf
 . w $$Image(rtgif, "", "Root")_"</TR>"
 q
TDid(facenum, type)
 q pos_side_tx_type_facenum
 
clickstr(facenum, type)
 q "PAAdm_Dental_Odontgram_ClickHandler("""_pos_""", """_side_""", """_tx_""", """_type_""", """_facenum_""",this);"
 
Image(path, facenum, type)
 q "<IMG src='"_path_"' onclick='"_$$clickstr($g(facenum), $g(type))_"'></TD>"_CrLf
}

*/
}
