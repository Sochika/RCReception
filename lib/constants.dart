import 'package:attendance/models/settings.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const inputColor = Color(0xFF2A2D33);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

const eventCats = {1:'Convocation', 2:'Business Meeting', 3:'Convocation by DM', 4:'Pythagoras', 5:'Thanksgiving', 6:'Workshop', 7:'Forum Class', 8:'Degree Class'};
const ABs = {1:'Thales Lodge', 2:'Dabaye Amaso Lodge', 3:'Akhnaton Chapter', 4:'Ee-Dee Pronaos', 5:'St Germain Pronaos', 6:'The Rose Pronaos', 7:'Arcane Pronaos', 0:'Not Affiliated',};
const GCAs ={1:'Rivers'};

const YesNo ={1:'Yes', 0: 'No'};

const male = 'Male';
const female = 'Female';
const String fileToDownload = 'members_sample.xlsx';

SettingsLoad settingConst = SettingsLoad(id: 0, abID: 0, gcaID: 0, userName: 'SuchTree');
