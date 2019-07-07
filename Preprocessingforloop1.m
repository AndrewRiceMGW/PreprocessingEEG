function Preprocessingforloop1(pathname)

file_list = dir([pathname filesep() '*.bdf']);
numsubjects = length(file_list);
file_name_list = {file_list.name};



for s=1:numsubjects



subject = file_name_list{s};

subjectfolderRaw = [pathname '/' subject];
subjectfolderICA = [pathname '/Subject'];

fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);


    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    EEG = pop_biosig(subjectfolderRaw);

    EEG= pop_chanedit(EEG, 'lookup','Standard-10-5-Cap385.sfp');

    EEG = pop_reref( EEG, [65 66] );
    
    EEG = pop_eegfiltnew(EEG, 'locutoff',1,'plotfreqz',1);
  
    EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:70] ,...
        'computepower',1,'linefreqs',[50 100] ,'normSpectrum',0,'p',0.01,...
        'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels',...
        'tau',100,'verb',1,'winsize',4,'winstep',1);


    EEG = pop_select( EEG, 'nochannel',...
        {'EXG3' 'EXG4' 'EXG5' 'EXG6' 'EXG7' 'EXG8'});
    
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
    
    EEG = pop_editset(EEG, 'setname', [subject '_ICA']);

    EEG = pop_saveset( EEG, 'filename', [subject '_ICA.set'],'filepath', subjectfolderICA);
    
    EEG = eeg_checkset( EEG );


end;


