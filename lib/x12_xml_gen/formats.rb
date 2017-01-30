require 'stupidedi'
require 'tty-table'

module X12XmlGen
  FORMATS =
    [
      #[ "004010", "HP", "835", Stupidedi::Versions::FunctionalGroups::FortyTen::TransactionSetDefs::HP835 ],
      #[ "005010", "HN", "277", Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HN277 ],
      #[ "005010", "HP", "835", Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835 ],
      #[ "005010", "HC", "837", Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837 ],
      #[ "005010", "FA", "999", Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::FA999 ],

      #[ "004010X091A1", "HP", "835", Stupidedi::Guides::FortyTen::X091A1::HP835 ],
      #[ "005010X214",   "HN", "277", Stupidedi::Guides::FiftyTen::X214::HN277 ],
      #[ "005010X221",   "HP", "835", Stupidedi::Guides::FiftyTen::X221::HP835 ],
      #[ "005010X222",   "HC", "837", Stupidedi::Guides::FiftyTen::X222::HC837P ],
      #[ "005010X231",   "FA", "999", Stupidedi::Guides::FiftyTen::X231::FA999 ],
      #[ "005010X221A1", "HP", "835", Stupidedi::Guides::FiftyTen::X221A1::HP835 ],
      [ "005010X222A1", "HC", "837", Stupidedi::Guides::FiftyTen::X222A1::HC837P ],
      #[ "005010X231A1", "FA", "999", Stupidedi::Guides::FiftyTen::X231A1::FA999 ],

      #[ "004010", "PO", "850", Stupidedi::Contrib::FortyTen::Guides::PO850 ],
      #[ "004010", "OW", "940", Stupidedi::Contrib::FortyTen::Guides::OW940 ],
      #[ "004010", "AR", "943", Stupidedi::Contrib::FortyTen::Guides::AR943 ],
      #[ "004010", "RE", "944", Stupidedi::Contrib::FortyTen::Guides::RE944 ],
      #[ "004010", "SW", "945", Stupidedi::Contrib::FortyTen::Guides::SW945 ],
      #[ "004010", "SM", "204", Stupidedi::Contrib::FortyTen::Guides::SM204 ],
      #[ "004010", "QM", "214", Stupidedi::Contrib::FortyTen::Guides::QM214 ],
      #[ "004010", "GF", "990", Stupidedi::Contrib::FortyTen::Guides::GF990 ],
      #[ "004010", "SS", "862", Stupidedi::Contrib::FortyTen::Guides::SS862 ],
      #[ "004010", "PS", "830", Stupidedi::Contrib::FortyTen::Guides::PS830 ],
      #[ "004010", "SH", "856", Stupidedi::Contrib::FortyTen::Guides::SH856 ],
      #[ "004010", "SQ", "866", Stupidedi::Contrib::FortyTen::Guides::SQ866 ],
      #[ "004010", "FA", "997", Stupidedi::Contrib::FortyTen::Guides::FA997 ],
      #[ "004010", "SC", "832", Stupidedi::Contrib::FortyTen::Guides::SC832 ],

      #[ "002001", "SH", "856", Stupidedi::Contrib::TwoThousandOne::Guides::SH856 ],
      #[ "002001", "PO", "830", Stupidedi::Contrib::TwoThousandOne::Guides::PO830 ],
      #[ "002001", "FA", "997", Stupidedi::Contrib::TwoThousandOne::Guides::FA997 ],

      #[ "003010", "RA", "820", Stupidedi::Contrib::ThirtyTen::Guides::RA820 ],
      #[ "003010", "PO", "850", Stupidedi::Contrib::ThirtyTen::Guides::PO850 ],
      #[ "003010", "PC", "860", Stupidedi::Contrib::ThirtyTen::Guides::PC860 ],
      #[ "003010", "PS", "830", Stupidedi::Contrib::ThirtyTen::Guides::PS830 ],

      #[ "003040", "WA", "142", Stupidedi::Contrib::ThirtyForty::Guides::WA142 ],

      #[ "003050", "PO", "850", Stupidedi::Contrib::ThirtyFifty::Guides::PO850 ],
    ]

    def self.show
      table = TTY::Table.new [ 'SubType', '', 'Type', 'Class' ], FORMATS

      table.render(:unicode, padding: [1,2,1,2], border: { style: :blue })
    end
end
