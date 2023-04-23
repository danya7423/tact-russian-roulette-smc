import * as fs from 'fs';
import * as path from 'path';
import { Address, contractAddress } from "ton";
import { RussianRouletteContract } from "./output/russian-roulette_RussianRouletteContract";
import { prepareTactDeployment } from "@tact-lang/deployer";

(async () => {

    // Parameters
    let testnet = true;
    let packageName = 'russian-roulette_RussianRouletteContract.pkg';
    let owner = Address.parse('EQBppqtdVg9Iv0OAyYcln8GFXwPot1IVa1lT5maP_zwz9dmN');
    let init = await RussianRouletteContract.init(owner, BigInt(3), BigInt(1 * Math.pow(10, 9)), BigInt(1 * Math.pow(10, 9)));

    // Load required data
    let address = contractAddress(0, init);
    let data = init.data.toBoc();
    let pkg = fs.readFileSync(path.resolve(__dirname, 'output', packageName));

    // Prepareing
    console.log('Uploading package...');
    let prepare = await prepareTactDeployment({ pkg, data, testnet });

    // Deploying
    console.log("============================================================================================");
    console.log('Contract Address')
    console.log("============================================================================================");
    console.log();
    console.log(address.toString({ testOnly: testnet }));
    console.log();
    console.log("============================================================================================");
    console.log('Please, follow deployment link')
    console.log("============================================================================================");
    console.log();
    console.log(prepare);
    console.log();
    console.log("============================================================================================");
})();