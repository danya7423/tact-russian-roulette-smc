struct Data {
    bet: Int;
    chucksCount: Int;
    players: map<Int, Address>;
}

contract RussianRouletteContract {

    owner: Address;
    playersCount: Int as uint32 = 0;
    chucksCount: Int as uint32;
    bet: Int as uint32;
    fee: Int as uint32;
    players: map<Int, Address>;

    init(owner: Address, chucksCount: Int, bet: Int, fee: Int) {
        self.owner = owner;
        self.chucksCount = chucksCount;
        self.bet = bet;
        self.fee = fee;
    }

    receive() {
        let ctx: Context = context();
        let bet: Int = ctx.value;

        require(ctx.value == self.bet, "invalid bet");

        self.players.set(self.playersCount, context().sender);
        self.playersCount = self.playersCount + 1;

        if (self.playersCount == self.chucksCount) {
            let chuck: Int = random(0, self.chucksCount);

            let winner: Address = self.players.get(chuck)!!;

            send(SendParameters{
                to: winner,
                value: (self.bet * self.chucksCount) - self.fee,
                bounce: false, 
                body: "Congratulations! You have won!".asComment()
            });
            send(SendParameters{
                to: self.owner,
                value: 0,
                mode: SendRemainingBalance + SendIgnoreErrors,
                bounce: false, 
                body: "Fee".asComment()
            });
        }
    }

    get fun get_data(): Data {
        return Data{
            bet: self.bet,
            chucksCount: self.chucksCount,
            players: self.players
        };
    }
}