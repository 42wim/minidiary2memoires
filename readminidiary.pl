#!/usr/bin/perl

use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=input/mini_diary.db",{ RaiseError => 1 }) or die $DBI::errstr;
print "delete from memo;delete from attachement;";
my $stm = $dbh->prepare("select _id,datetime,note,thumb_view from diary");
$stm->execute();
while ( $row = $stm->fetch() ) {
	$row->[2]=~s/\'/\'\'/g;
	$sql="INSERT INTO memo VALUES(".$row->[0].",'".$row->[2]."','".$row->[2]."','ordinary',1,".$row->[1].",".$row->[1].",'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);";
	print "$sql\n";
	if ($row->[3] ne '') {
		open IMAGE, ">output/attachements/images/a43-".$row->[1].".jpg" or die $!;
		print IMAGE $row->[3];
		close(IMAGE);
		$cmd="file output/attachements/images/a43-".$row->[1].".jpg";
		$input=`$cmd`;
		chomp($input);
		if ($input=~/(\d+) x (\d+)/) {
			$w=$1;
			$h=$2;
		}
		unless ($input=~/empty/i) {
			$sql="INSERT INTO attachement VALUES(NULL,".$row->[0].",'file:///mnt/sdcard/.memoires/attachements/images/a43-".$row->[1].".jpg','image/jpeg','".$w."','".$h."',NULL,'',NULL,NULL,'".$row->[1]."',NULL);";
			print "$sql\n";
		}
	}
}
$stm->finish();
$dbh->disconnect();
